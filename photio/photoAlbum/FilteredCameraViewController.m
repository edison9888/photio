//
//  FilteredCameraViewController.m
//  photio
//
//  Created by Troy Stribling on 6/1/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "FilteredCameraViewController.h"
#import "ParameterSliderView.h"
#import "ViewGeneral.h"
#import <AssetsLibrary/AssetsLibrary.h>

#define CAMERA_SHUTTER_TRANSITION     0.2f

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface FilteredCameraViewController (PrivateAPI)

- (IBAction)captureStillImage:(id)sender;
- (void)snapShutter;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation FilteredCameraViewController

@synthesize containerView, delegate, captureImageGesture, cameraControlsView, cameraConfigView, 
            selectedCameraView, autoAdjustView, parameterView, stillCamera, filter, transitionGestureRecognizer;

#pragma mark -
#pragma mark FilteredCameraViewController PrivateAPI

- (IBAction)captureStillImage:(id)sender {
    self.captureImageGesture.enabled = NO;
    [self snapShutter];
    [self.stillCamera capturePhotoAsJPEGProcessedUpToFilter:self.filter withCompletionHandler:^(NSData* imageData, NSError* error){
        if (error) {
            [ViewGeneral alertOnError:error];
        }
        else {
            UIImage* capturedImage = [[UIImage alloc] initWithData:imageData];
            if ([self.delegate respondsToSelector:@selector(didCaptureImage:)]) {
                [self.delegate didCaptureImage:capturedImage];
            }
        }             
        runOnMainQueueWithoutDeadlocking(^{
            self.captureImageGesture.enabled = YES;
        });
    }];
}

- (void)snapShutter {
    __block UIView* shutter = [[UIImageView alloc] initWithFrame:self.view.frame];
    shutter.backgroundColor = [UIColor blackColor];
    shutter.alpha = 0.0;
    [self.view addSubview:shutter];
    [UIView animateWithDuration:CAMERA_SHUTTER_TRANSITION
        delay:0.0
        options:UIViewAnimationOptionCurveEaseOut
        animations:^{
          shutter.alpha = 1.0;
        }
        completion:^(BOOL _finished){
            [UIView animateWithDuration:CAMERA_SHUTTER_TRANSITION 
                delay:0.0 
                options:UIViewAnimationOptionCurveEaseOut 
                animations:^{
                    shutter.alpha = 0.0;
                }
                completion:^(BOOL _finished) {
                    [shutter removeFromSuperview];
                }
            ];
        }
    ];
}


#pragma mark -
#pragma mark FilteredCameraViewController

+ (id)inView:(UIView*)_containerView {
    return [[FilteredCameraViewController alloc] initWithNibName:@"FilteredCameraViewController" bundle:nil inView:_containerView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.containerView = _containerView;
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self.view relativeToView:self.containerView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stillCamera = [[GPUImageStillCamera alloc] init];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.filter = [[GPUImageGammaFilter alloc] init];
//    self.filter = [[GPUImageSketchFilter alloc] init];
//    [(GPUImageSketchFilter*)filter setTexelHeight:(1.0 / 1024.0)];
//    [(GPUImageSketchFilter*)filter setTexelWidth:(1.0 / 768.0)];
	[self.filter prepareForImageCapture];    
    [self.stillCamera addTarget:filter];
    GPUImageView* filterView = (GPUImageView*)self.view;
    filterView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    [self.filter addTarget:filterView];    
    [self.stillCamera startCameraCapture];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark TransitionGestureRecognizerDelegate

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] dragCamera:_drag];    
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    [[ViewGeneral instance] dragCamera:_drag];    
}

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] dragCameraToInspectImage:_drag];
}

- (void)didReleaseRight:(CGPoint)_location {
    [[ViewGeneral instance] releaseCamera];
}

- (void)didReleaseLeft:(CGPoint)_location {
    [[ViewGeneral instance] releaseCamera];
}

- (void)didReleaseUp:(CGPoint)_location {
}

- (void)didReleaseDown:(CGPoint)_location {
    [[ViewGeneral instance] releaseCameraInspectImage];
}

- (void)didSwipeRight:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionCameraToLocales];    
}

- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionCameraToCalendar];    
}

- (void)didSwipeUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self.stillCamera rotateCamera];
}

- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionCameraToInspectImage];
}

- (void)didReachMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionCameraToLocales];    
}

- (void)didReachMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    [[ViewGeneral instance] transitionCameraToCalendar];    
}

- (void)didReachMaxDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
//    [self toggleCamera];
//    [self setFlashImage];
}

- (void)didReachMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    [[ViewGeneral instance] transitionCameraToInspectImage];
}

@end
