//
//  Camera.m
//  photio
//
//  Created by Troy Stribling on 3/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "Camera.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/CGImageProperties.h>

@interface Camera (PrivateAPI)

+ (AVCaptureConnection*)connectionWithMediaType:(NSString*)_mediaType fromConnections:(NSArray*)_connections ;
- (AVCaptureDevice*)cameraWithPosition:(AVCaptureDevicePosition)position;
- (AVCaptureDevice*)frontFacingCamera;
- (AVCaptureDevice*)backFacingCamera;
- (void)removeFile:(NSURL*)outputFileURL;
- (void)copyFileToDocuments:(NSURL*)fileURL;

@end


#pragma mark -
@implementation Camera

@synthesize session, orientation, videoInput, stillImageOutput, deviceConnectedObserver, deviceDisconnectedObserver,
            backgroundRecordingID, delegate;

- (id) init {
    self = [super init];
    if (self != nil) {
		__block id weakSelf = self;
        
        void (^deviceConnectedBlock)(NSNotification*) = ^(NSNotification* notification) {
			AVCaptureDevice* device = [notification object];
			BOOL sessionHasDeviceWithMatchingMediaType = NO;
			NSString* deviceMediaType = nil;
            
			if ([device hasMediaType:AVMediaTypeAudio]) {
                deviceMediaType = AVMediaTypeAudio;
			} else if ([device hasMediaType:AVMediaTypeVideo]) {
                deviceMediaType = AVMediaTypeVideo;
            }
			
			if (deviceMediaType != nil) {
				for (AVCaptureDeviceInput *input in [session inputs]) {
					if ([[input device] hasMediaType:deviceMediaType]) {
						sessionHasDeviceWithMatchingMediaType = YES;
						break;
					}
				}
				if (!sessionHasDeviceWithMatchingMediaType) {
					NSError	*error;
					AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
					if ([session canAddInput:input]) {
						[session addInput:input];
                    }
				}				
			}
        };
        
        void (^deviceDisconnectedBlock)(NSNotification*) = ^(NSNotification* notification) {
			AVCaptureDevice *device = [notification object];
			
			if ([device hasMediaType:AVMediaTypeVideo]) {
				[self.session removeInput:[weakSelf videoInput]];
				[weakSelf setVideoInput:nil];
			}
			
        };
        
        NSNotificationCenter* notificationCenter = [NSNotificationCenter defaultCenter];
        [self setDeviceConnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasConnectedNotification object:nil queue:nil usingBlock:deviceConnectedBlock]];
        [self setDeviceDisconnectedObserver:[notificationCenter addObserverForName:AVCaptureDeviceWasDisconnectedNotification object:nil queue:nil usingBlock:deviceDisconnectedBlock]];
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[notificationCenter addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
		self.orientation = AVCaptureVideoOrientationPortrait;
    }
    
    return self;
}

- (void)setupSession {    	
    AVCaptureDeviceInput* newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:nil];
    AVCaptureStillImageOutput* newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary* outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [newStillImageOutput setOutputSettings:outputSettings];
    AVCaptureSession *newCaptureSession = [[AVCaptureSession alloc] init];
    if ([newCaptureSession canAddInput:newVideoInput]) {
        [newCaptureSession addInput:newVideoInput];
    }
    if ([newCaptureSession canAddOutput:newStillImageOutput]) {
        [newCaptureSession addOutput:newStillImageOutput];
    }
    [self setStillImageOutput:newStillImageOutput];
    [self setVideoInput:newVideoInput];
    [self setSession:newCaptureSession];
}

- (void)captureStillImage {
    AVCaptureConnection *stillImageConnection = [self.class connectionWithMediaType:AVMediaTypeVideo fromConnections:[self.stillImageOutput connections]];
    if ([stillImageConnection isVideoOrientationSupported]) {
        [stillImageConnection setVideoOrientation:orientation];
    }
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
        completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError* error) {
            ALAssetsLibraryWriteImageCompletionBlock completionBlock = ^(NSURL *assetURL, NSError *error) {
                if (error) {
                    if ([self.delegate respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                        [self.delegate camera:self didFailWithError:error];
                    }
                }
            };
            if (imageDataSampleBuffer != NULL) {
                NSData* imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage* image = [[UIImage alloc] initWithData:imageData];
                ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
                [library writeImageToSavedPhotosAlbum:[image CGImage] orientation:(ALAssetOrientation)[image imageOrientation] completionBlock:completionBlock];
            } else {
                completionBlock(nil, error);
            }
        }
     ];
}

- (BOOL) toggleCamera {
    BOOL success = NO;
    if ([self cameraCount] > 1) {
        NSError *error;
        AVCaptureDeviceInput* newVideoInput;
        AVCaptureDevicePosition position = [[self.videoInput device] position];        
        if (position == AVCaptureDevicePositionBack) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self frontFacingCamera] error:&error];
        } else if (position == AVCaptureDevicePositionFront) {
            newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:[self backFacingCamera] error:&error];
        } else {
            return success;
        }        
        if (newVideoInput != nil) {
            [self.session beginConfiguration];
            [self.session removeInput:[self videoInput]];
            if ([self.session canAddInput:newVideoInput]) {
                [self.session addInput:newVideoInput];
                self.videoInput = newVideoInput;
            } else {
                [self.session addInput:[self videoInput]];
            }
            [self.session commitConfiguration];
            success = YES;
        } else if (error) {
            if ([self.delegate respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [self.delegate camera:self didFailWithError:error];
            }
        }
    }
    return success;
}


- (NSUInteger) cameraCount {
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
}

- (void) autoFocusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [self.videoInput device];
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            [device setFocusPointOfInterest:point];
            [device setFocusMode:AVCaptureFocusModeAutoFocus];
            [device unlockForConfiguration];
        } else {
            if ([self.delegate respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [self.delegate camera:self didFailWithError:error];
            }
        }        
    }
}

- (void) continuousFocusAtPoint:(CGPoint)point {
    AVCaptureDevice *device = [self.videoInput device];
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
		NSError *error;
		if ([device lockForConfiguration:&error]) {
			[device setFocusPointOfInterest:point];
			[device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
			[device unlockForConfiguration];
		} else {
			if ([self.delegate respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [self.delegate camera:self didFailWithError:error];
			}
		}
	}
}

@end


#pragma mark -
#pragma mark Camera PrivateAPI
@implementation Camera (PrivateAPI)

+ (AVCaptureConnection*)connectionWithMediaType:(NSString*)_mediaType fromConnections:(NSArray*)_connections {
	for (AVCaptureConnection *connection in _connections) {
		for (AVCaptureInputPort* port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:_mediaType] ) {
				return connection;
			}
		}
	}
	return nil;
}

- (void)deviceOrientationDidChange {	
	UIDeviceOrientation deviceOrientation = [[UIDevice currentDevice] orientation];
	if (deviceOrientation == UIDeviceOrientationPortrait) {
		orientation = AVCaptureVideoOrientationPortrait;
	} else if (deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
		orientation = AVCaptureVideoOrientationPortraitUpsideDown;
    } else if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
		orientation = AVCaptureVideoOrientationLandscapeRight;
	} else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
		orientation = AVCaptureVideoOrientationLandscapeLeft;
    }
}

- (AVCaptureDevice*) cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice*)frontFacingCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice*)backFacingCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (void) removeFile:(NSURL*)fileURL {
    NSString *filePath = [fileURL path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePath]) {
        NSError *error;
        if ([fileManager removeItemAtPath:filePath error:&error] == NO) {
            if ([self.delegate respondsToSelector:@selector(captureManager:didFailWithError:)]) {
                [self.delegate camera:self didFailWithError:error];
            }            
        }
    }
}

- (void)copyFileToDocuments:(NSURL*)fileURL {
	NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	[dateFormatter setDateFormat:@"yyyy-MM-dd_HH-mm-ss"];
	NSString *destinationPath = [documentsDirectory stringByAppendingFormat:@"/output_%@.mov", [dateFormatter stringFromDate:[NSDate date]]];
	NSError	*error;
	if (![[NSFileManager defaultManager] copyItemAtURL:fileURL toURL:[NSURL fileURLWithPath:destinationPath] error:&error]) {
		if ([self.delegate respondsToSelector:@selector(captureManager:didFailWithError:)]) {
			[self.delegate camera:self didFailWithError:error];
		}
	}
}	
@end

