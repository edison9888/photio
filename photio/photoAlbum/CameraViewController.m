//
//  CameraViewController.m
//  photio
//
//  Created by Troy Stribling on 3/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CameraViewController.h"
#import "Camera.h"
#import "TransitionGestureRecognizer.h"

static void *AVCamFocusModeObserverContext = &AVCamFocusModeObserverContext;

@interface CameraViewController () <UIGestureRecognizerDelegate>
@end

@interface CameraViewController (PrivateAPI)

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates;
- (void)setFlashImage;
- (void)toggleCamera;

@end

@interface CameraViewController (CameraDelegate) <CameraDelegate>
@end

@interface CameraViewController (TransitionGestureRecognizerDelegate) <TransitionGestureRecognizerDelegate>
@end

@implementation CameraViewController

@synthesize camera, containerView, transitionGestureRecognizer, delegate, captureVideoPreviewLayer,
            takePhotoView, flashView, focusGesture, flashGesture;

#pragma mark -
#pragma mark UIView

- (void)viewDidLoad {
    
	if (self.camera == nil) {
		self.camera = [[Camera alloc] init];		
		self.camera.delegate = self;
		[self.camera setupSession];

        AVCaptureVideoPreviewLayer* newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:[self.camera session]];
        CALayer *viewLayer = [self.view layer];
        [viewLayer setMasksToBounds:YES];
        
        CGRect bounds = [self.view bounds];
        [newCaptureVideoPreviewLayer setFrame:bounds];
        if ([newCaptureVideoPreviewLayer isOrientationSupported]) {
            [newCaptureVideoPreviewLayer setOrientation:AVCaptureVideoOrientationPortrait];
        }
        [newCaptureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
        [viewLayer insertSublayer:newCaptureVideoPreviewLayer below:[[viewLayer sublayers] objectAtIndex:0]];
        [self setCaptureVideoPreviewLayer:newCaptureVideoPreviewLayer];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[self.camera session] startRunning];
        });
        [self.focusGesture requireGestureRecognizerToFail:self.flashGesture];
        [self continouslyAutoFocus];
        [self setFlashImage];
        [self.camera setFlashMode:AVCaptureFlashModeOff];
        self.takePhotoView.hidden = NO;
    }
    [super viewDidLoad];
}

#pragma mark -
#pragma mark CameraViewController

+ (id)inView:(UIView*)_containerView {
    return [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil inView:_containerView];;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {        
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self.view relativeToView:self.containerView];
    }
    return self;
}

- (void)saveImage:(UIImage*)_image {
    [self.camera saveImage:_image];
}

- (void)continouslyAutoFocus {
    if ([self.camera.videoInput.device isFocusPointOfInterestSupported])
        [self.camera continuousFocusAtPoint:CGPointMake(.5f, .5f)];
}

- (IBAction)captureStillImage:(id)sender {
    [self.camera captureStillImage];
}

- (IBAction)changeFlashMode:(id)sender {
    switch ([self.camera flashMode]) {
        case AVCaptureFlashModeOff:
            [self.camera setFlashMode:AVCaptureFlashModeOn];
            break;
        case AVCaptureFlashModeOn:
            [self.camera setFlashMode:AVCaptureFlashModeOff];
            break;
        case AVCaptureFlashModeAuto:
            [self.camera setFlashMode:AVCaptureFlashModeOn];
            break;
    }
    [self setFlashImage];
}

- (IBAction)autoFocus:(UIGestureRecognizer*)gestureRecognizer {
    if ([self.camera.videoInput.device isFocusPointOfInterestSupported]) {
        CGPoint tapPoint = [gestureRecognizer locationInView:self.view];
        CGPoint convertedFocusPoint = [self convertToPointOfInterestFromViewCoordinates:tapPoint];
        [self.camera autoFocusAtPoint:convertedFocusPoint];
    }
}

@end

#pragma mark -
#pragma mark CameraViewController PrivateAPI
@implementation CameraViewController (PrivateAPI)

- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates  {
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = self.view.frame.size;
    if ([captureVideoPreviewLayer isMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }    
    if ( [[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [self.camera.videoInput ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                if ( [[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
						// If point is inside letterboxed area, do coordinate conversion; otherwise, don't change the default value returned (.5,.5)
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
							// Scale (accounting for the letterboxing on the left and right of the video preview), switch x and y, and reverse x
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
						// If point is inside letterboxed area, do coordinate conversion. Otherwise, don't change the default value returned (.5,.5)
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
							// Scale (accounting for the letterboxing on the top and bottom of the video preview), switch x and y, and reverse x
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[captureVideoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
					// Scale, switch x and y, and reverse x
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2; // Account for cropped height
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2); // Account for cropped width
                        xc = point.y / frameSize.height;
                    }
                }                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    return pointOfInterest;
}

- (void)setFlashImage {
    if ([self.camera selectedCamera] == AVCaptureDevicePositionBack) {
        switch ([self.camera flashMode]) {
            case AVCaptureFlashModeOff:
                self.flashView.hidden = YES;
                break;
            case AVCaptureFlashModeOn:
                self.flashView.hidden = NO;
                break;
            case AVCaptureFlashModeAuto:
                self.flashView.hidden = NO;
                break;
        }
    } else {
        self.flashView.hidden = YES;
    }
}

- (void)toggleCamera {
    [self.camera toggleCamera];
    [self continouslyAutoFocus];
}

@end

#pragma mark -
#pragma mark CameraViewController CameraDelegate
@implementation CameraViewController (CameraDelegate)

- (void)camera:(Camera*)_camera didFailWithError:(NSError *)error {
    CFRunLoopPerformBlock(CFRunLoopGetMain(), kCFRunLoopCommonModes, ^(void) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription] message:[error localizedFailureReason]
                                                delegate:nil
                                                cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title")
                                                otherButtonTitles:nil];
        [alertView show];
    });
}

- (void)camera:(Camera*)_camera didCaptureImage:(UIImage*)_image {
    [self.delegate didCaptureImage:_image];
}

@end

#pragma mark -
#pragma mark TransitionGestureRecognizerDelegate
@implementation CameraViewController (TransitionGestureRecognizerDelegate)

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didDragCameraRight:from:withVelocity:)]) {
        [self.delegate didDragCameraRight:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(didDragCameraLeft:from:withVelocity:)]) {
        [self.delegate didDragCameraLeft:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didDragCameraDown:from:withVelocity:)]) {
        [self.delegate didDragCameraDown:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didReleaseRight:(CGPoint)_location {    
    if ([self.delegate respondsToSelector:@selector(didReleaseCameraRight:)]) {
        [self.delegate didReleaseCameraRight:_location];
    }
}

- (void)didReleaseLeft:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(didReleaseCameraLeft:)]) {
        [self.delegate didReleaseCameraLeft:_location];
    }
}

- (void)didReleaseUp:(CGPoint)_location {
}

- (void)didReleaseDown:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(didReleaseCameraDown:)]) {
        [self.delegate didReleaseCameraDown:_location];
    }
}

- (void)didSwipeRight:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didSwipeCameraRight:withVelocity:)]) {
        [self.delegate didSwipeCameraRight:_location withVelocity:_velocity];
    }
}

- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didSwipeCameraLeft:withVelocity:)]) {
        [self.delegate didSwipeCameraLeft:_location withVelocity:_velocity];
    }
}

- (void)didSwipeUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self toggleCamera];
    [self setFlashImage];
}

- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didSwipeCameraDown:withVelocity:)]) {
        [self.delegate didSwipeCameraDown:_location withVelocity:_velocity];
    }
}

- (void)didReachMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didReachCameraMaxDragRight:from:withVelocity:)]) {
        [self.delegate didReachCameraMaxDragRight:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didReachMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(didReachCameraMaxDragLeft:from:withVelocity:)]) {
        [self.delegate didReachCameraMaxDragLeft:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didReachMaxDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
}

- (void)didReachMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(didReachCameraMaxDragDown:from:withVelocity:)]) {
        [self.delegate didReachCameraMaxDragDown:_drag from:_location withVelocity:_velocity];
    }
}

@end

