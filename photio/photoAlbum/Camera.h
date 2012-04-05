//
//  Camera.h
//  photio
//
//  Created by Troy Stribling on 3/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol CameraDelegate;

@interface Camera : NSObject {
}

@property (nonatomic,retain) AVCaptureSession*                  session;
@property (nonatomic,assign) AVCaptureVideoOrientation          orientation;
@property (nonatomic,retain) AVCaptureDeviceInput*              videoInput;
@property (nonatomic,retain) AVCaptureStillImageOutput*         stillImageOutput;
@property (nonatomic,assign) id                                 deviceConnectedObserver;
@property (nonatomic,assign) id                                 deviceDisconnectedObserver;
@property (nonatomic,assign) UIBackgroundTaskIdentifier         backgroundRecordingID;
@property (nonatomic,assign) id <CameraDelegate>                delegate;

- (void)setupSession;
- (void)captureStillImage;
- (BOOL)toggleCamera;
- (NSUInteger)cameraCount;
- (void)autoFocusAtPoint:(CGPoint)_point;
- (void)continuousFocusAtPoint:(CGPoint)_point;
- (void)saveImage:(UIImage*)_image;
- (AVCaptureFlashMode)flashMode;
- (void)setFlashMode:(AVCaptureFlashMode)_flashmode;
- (AVCaptureDevicePosition)selectedCamera;

@end

@protocol CameraDelegate <NSObject>

@required

- (void)camera:(Camera*)_camera didFailWithError:(NSError*)_error;
- (void)camera:(Camera*)_camera didCaptureImage:(UIImage*)_image;

@end
