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
@property (nonatomic, weak)   id <CameraViewControllerDelegate> cameraDelegate;
@property (nonatomic, retain) Camera*                           camera;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer*       captureVideoPreviewLayer;
@property (nonatomic, retain) TransitionGestureRecognizer*      transitionGestureRecognizer;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (void)setFlashImage;
- (IBAction)captureStillImage:(id)sender;
- (IBAction)changeFlashMode:(id)sender;

@end

@protocol CameraViewControllerDelegate <NSObject>

- (void)didTakePicture:(UIImage*)_picture;

@end

