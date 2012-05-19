//
//  CameraViewController.m
//  photio
//
//  Created by Troy Stribling on 3/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"

@protocol CameraViewControllerDelegate;
@class Camera, AVCamPreviewView, AVCaptureVideoPreviewLayer;

@interface CameraViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
}

@property (nonatomic, weak)   UIView*                           containerView;
@property (nonatomic, strong) IBOutlet UIView*                  takePhotoView;
@property (nonatomic, strong) IBOutlet UIView*                  flashView;
@property (nonatomic, strong) IBOutlet UIGestureRecognizer*     continuousFocusGesture;
@property (nonatomic, strong) IBOutlet UIGestureRecognizer*     focusGesture;
@property (nonatomic, strong) IBOutlet UIGestureRecognizer*     flashGesture;
@property (nonatomic, weak)   id <CameraViewControllerDelegate> delegate;
@property (nonatomic, strong) Camera*                           camera;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer*       captureVideoPreviewLayer;
@property (nonatomic, strong) TransitionGestureRecognizer*      transitionGestureRecognizer;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (void)saveImage:(UIImage*)_image;
- (void)continouslyAutoFocus;

@end

@protocol CameraViewControllerDelegate <NSObject>

@required

- (void)didCaptureImage:(UIImage*)_image;

@optional

- (void)didDragCameraRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didDragCameraLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didDragCameraDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;

- (void)didReleaseCameraRight:(CGPoint)_location;
- (void)didReleaseCameraLeft:(CGPoint)_location;
- (void)didReleaseCameraDown:(CGPoint)_location;

- (void)didSwipeCameraRight:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didSwipeCameraLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didSwipeCameraDown:(CGPoint)_location withVelocity:(CGPoint)_velocity;

- (void)didReachCameraMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didReachCameraMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didReachCameraMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;

@end

