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
- (void)autoFocusAtPoint:(CGPoint)point;
- (void)continuousFocusAtPoint:(CGPoint)point;

@end

@protocol CameraDelegate <NSObject>

@optional

- (void)camera:(Camera*)_camera didFailWithError:(NSError *)error;
- (void)cameraStillImageCaptured:(Camera*)_camera;
- (void)cameraDeviceConfigurationChanged:(Camera*)_camera;

@end
