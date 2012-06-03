//
//  FilteredCameraViewController.h
//  photio
//
//  Created by Troy Stribling on 6/1/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"
#import "GPUImage.h"

@protocol FilteredCameraViewControllerDelegate;

@class ParameterSliderView;

@interface FilteredCameraViewController : UIViewController <TransitionGestureRecognizerDelegate>

@property(nonatomic, weak)      UIView*                                     containerView;
@property(nonatomic, weak)      id<FilteredCameraViewControllerDelegate>    delegate;
@property(nonatomic, strong)    IBOutlet UIGestureRecognizer*               captureImageGesture;
@property(nonatomic, strong)    IBOutlet UIView*                            cameraControlsView;
@property(nonatomic, strong)    IBOutlet UIView*                            cameraConfigView;
@property(nonatomic, strong)    IBOutlet UIImageView*                       selectedCameraView;
@property(nonatomic, strong)    IBOutlet UIImageView*                       autoAdjustView;
@property(nonatomic, strong)    IBOutlet ParameterSliderView*               parameterView;
@property(nonatomic, strong)    GPUImageStillCamera*                        stillCamera;
@property(nonatomic, strong)    GPUImageOutput<GPUImageInput>*              filter;
@property(nonatomic, strong)    TransitionGestureRecognizer*                transitionGestureRecognizer;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end

@protocol FilteredCameraViewControllerDelegate <NSObject>

@required

- (void)didCaptureImage:(UIImage*)_image;

@end
