//
//  NativeCamera.h
//  photio
//
//  Created by Troy Stribling on 3/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol NativeCameraDelegate;

@interface NativeCamera : NSObject {
}

@property (nonatomic, strong) AVCaptureSession*                 session;
@property (nonatomic, assign) AVCaptureVideoOrientation         orientation;
@property (nonatomic, strong) AVCaptureDeviceInput*             videoInput;
@property (nonatomic, strong) AVCaptureStillImageOutput*        stillImageOutput;
@property (nonatomic, assign) id                                deviceConnectedObserver;
@property (nonatomic, assign) id                                deviceDisconnectedObserver;
@property (nonatomic, assign) UIBackgroundTaskIdentifier        backgroundRecordingID;
@property (nonatomic, assign) id <NativeCameraDelegate>         delegate;

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

@protocol NativeCameraDelegate <NSObject>

@required

- (void)camera:(NativeCamera*)_camera didFailWithError:(NSError*)_error;
- (void)camera:(NativeCamera*)_camera didCaptureImage:(UIImage*)_image;

@end
