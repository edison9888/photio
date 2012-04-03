//
//  ViewGeneral.m
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ViewGeneral.h"
#import "UIImage+Resize.h"

#import "ImageInspectViewController.h"
#import "EntryViewController.h"
#import "CalendarViewController.h"
#import "LocalesViewController.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ViewGeneral* thisViewControllerGeneral = nil;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewGeneral (PrivateAPI)

- (void)transition:(CGFloat)_duration withAnimation:(void(^)(void))_animation;
- (void)drag:(CGPoint)_drag view:(UIView*)_view;
- (CGFloat)verticalReleaseDuration:(CGFloat)_offset;
- (CGFloat)horizontaltReleaseDuration:(CGFloat)_offset;
- (CGFloat)verticalTransitionDuration:(CGFloat)_offset;
- (CGFloat)horizontalTransitionDuration:(CGFloat)_offset;

@end

//-----------------------------------------------------------------------------------------------------------------------------------
@implementation ViewGeneral
 
@synthesize notAnimating;
@synthesize imageInspectViewController, cameraViewController, entryViewController, calendarViewController, localesViewController;

#pragma mark - 
#pragma mark ViewGeneral PrivateApi

- (void)transition:(CGFloat)_duration withAnimation:(void(^)(void))_animation {
    if (self.notAnimating) {
        self.notAnimating = NO;
        [UIView animateWithDuration:_duration
            delay:0
            options:UIViewAnimationOptionCurveEaseOut
            animations:_animation
            completion:^(BOOL _finished){
                self.notAnimating = YES;
            }
        ];
    }
}

- (void)drag:(CGPoint)_drag view:(UIView*)_view {
    if (self.notAnimating) {
        _view.transform = CGAffineTransformTranslate(_view.transform, _drag.x, _drag.y);
    }
}

- (CGFloat)verticalReleaseDuration:(CGFloat)_offset  {
    return abs(_offset) / RELEASE_ANIMATION_SPEED;    
}

- (CGFloat)horizontaltReleaseDuration:(CGFloat)_offset  {
    return abs(_offset) / RELEASE_ANIMATION_SPEED;    
}

- (CGFloat)verticalTransitionDuration:(CGFloat)_offset {
    CGRect screenBounds = [self.class screenBounds];
    return (screenBounds.size.height - abs(_offset)) / TRANSITION_ANIMATION_SPEED;    
}

- (CGFloat)horizontalTransitionDuration:(CGFloat)_offset {
    CGRect screenBounds = [self.class screenBounds];
    return (screenBounds.size.width  - abs(_offset)) / TRANSITION_ANIMATION_SPEED;    
}

- (void)saveImage:(UIImage*)_image {
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[_image CGImage] orientation:(ALAssetOrientation)[_image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){}];
}

+ (ViewGeneral*)instance {	
    @synchronized(self) {
        if (thisViewControllerGeneral == nil) {
            thisViewControllerGeneral = [[self alloc] init]; 
            thisViewControllerGeneral.notAnimating = YES;
        }
    }
    return thisViewControllerGeneral;
}

+ (CGRect)screenBounds {
    return [[UIScreen mainScreen] bounds];
}

+ (CGRect)inWindow {
    return [self screenBounds];
}

+ (CGRect)overWindow {
    CGRect screenBounds = [self screenBounds];
    return CGRectMake(screenBounds.origin.x, -screenBounds.size.height - VIEW_MIN_SPACING, screenBounds.size.width, screenBounds.size.height);
}

+ (CGRect)underWindow {
    CGRect screenBounds = [self screenBounds];
    return CGRectMake(screenBounds.origin.x, screenBounds.size.height + VIEW_MIN_SPACING, screenBounds.size.width, screenBounds.size.height);
}

+ (CGRect)leftOfWindow {
    CGRect screenBounds = [self screenBounds];
    return CGRectMake(-screenBounds.size.width - VIEW_MIN_SPACING, screenBounds.origin.y, screenBounds.size.width, screenBounds.size.height);
}

+ (CGRect)rightOfWindow {
    CGRect screenBounds = [self screenBounds];
    return CGRectMake(screenBounds.size.width + VIEW_MIN_SPACING, screenBounds.origin.y, screenBounds.size.width, screenBounds.size.height);
}

- (void)createViews:(UIView*)_containerView {
    [self initEntryView:_containerView];
    [self initImageInspectView:_containerView];
    [self initCameraView:_containerView];
    [self initCalendarView:_containerView];
    [self initLocalesView:_containerView];
}

#pragma mark - 
#pragma mark EntryViewController

- (void)initEntryView:(UIView*)_containerView {
    if (self.entryViewController == nil) {
        self.entryViewController = [EntryViewController inView:_containerView];
    }
    [self entryViewPosition:[self.class underWindow]];
    [_containerView addSubview:self.entryViewController.view];
}

- (void)entryViewHidden:(BOOL)_hidden {
    self.entryViewController.view.hidden = _hidden;
}

- (void)entryViewPosition:(CGRect)_rect {
    self.entryViewController.view.frame = _rect;
}

#pragma mark - 
#pragma mark ImageInspectViewController

- (void)initImageInspectView:(UIView*)_containerView {
    if (self.imageInspectViewController == nil) {
        self.imageInspectViewController = [ImageInspectViewController inView:_containerView];
    } 
    [self imageInspectViewPosition:[self.class overWindow]];
    [_containerView addSubview:self.imageInspectViewController.view];
}

- (void)imageInspectViewHidden:(BOOL)_hidden {
    self.imageInspectViewController.view.hidden = _hidden;
}

- (void)imageInspectViewPosition:(CGRect)_rect {
    self.imageInspectViewController.view.frame = _rect;
}

#pragma mark - 
#pragma mark CameraViewController

- (void)initCameraView:(UIView*)_containerView {
    if (self.cameraViewController == nil) {
        self.cameraViewController = [CameraViewController inView:_containerView];
    } 
    [self cameraViewPosition:[self.class inWindow]];
    self.cameraViewController.delegate = self;
    [_containerView addSubview:self.cameraViewController.view];
}

- (void)cameraViewHidden:(BOOL)_hidden {
    self.cameraViewController.view.hidden = _hidden;
}

- (void)cameraViewPosition:(CGRect)_rect {
    self.cameraViewController.view.frame = _rect;
}

#pragma mark - 
#pragma mark CalendarViewController

- (void)initCalendarView:(UIView*)_containerView {
    if (self.calendarViewController == nil) {
        self.calendarViewController = [CalendarViewController inView:_containerView];
    } 
    [self calendarViewPosition:[self.class rightOfWindow]];
    [_containerView addSubview:self.calendarViewController.view];
}

- (void)calendarViewHidden:(BOOL)_hidden {
    self.calendarViewController.view.hidden = _hidden;
}

- (void)calendarViewPosition:(CGRect)_rect {
    self.calendarViewController.view.frame = _rect;
}

#pragma mark - 
#pragma mark LocalesViewController

- (void)initLocalesView:(UIView*)_containerView {
    if (self.localesViewController == nil) {
        self.localesViewController = [LocalesViewController inView:_containerView];
    } 
    [self localesViewPosition:[self.class leftOfWindow]];
    [_containerView addSubview:self.localesViewController.view];
}

- (void)localesViewHidden:(BOOL)_hidden {
    self.localesViewController.view.hidden = _hidden;
}

- (void)localesViewPosition:(CGRect)_rect {
    self.localesViewController.view.frame = _rect;
}

#pragma mark - 
#pragma mark Calendar To Camera

- (void)transitionCalendarToCamera {
    [self.cameraViewController setFlashImage];
    [self transition:[self horizontalTransitionDuration:self.calendarViewController.view.frame.origin.x] withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self calendarViewPosition:[self.class rightOfWindow]];
        }
    ];    
}

- (void)releaseCalendar {
    [self transition:[self horizontaltReleaseDuration:self.calendarViewController.view.frame.origin.x] withAnimation:^{
            [self calendarViewPosition:[self.class inWindow]];
        }
    ];    
}

- (void)dragCalendar:(CGPoint)_drag {
    [self drag:_drag view:self.calendarViewController.view];
}

#pragma mark - 
#pragma mark Camera To Calendar

- (void)transitionCameraToCalendar {
    [self transition:[self horizontalTransitionDuration:self.cameraViewController.view.frame.origin.x] withAnimation:^{
            [self cameraViewPosition:[self.class leftOfWindow]];
            [self calendarViewPosition:[self.class inWindow]];
        }
    ];
}

- (void)releaseCamera {
    [self transition:[self horizontaltReleaseDuration:self.cameraViewController.view.frame.origin.x] withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
        }
    ];    
}

- (void)dragCamera:(CGPoint)_drag {
    [self drag:_drag view:self.cameraViewController.view];
}

#pragma mark - 
#pragma mark Camera To Locales

- (void)transitionCameraToLocales {
    [self transition:[self horizontalTransitionDuration:self.cameraViewController.view.frame.origin.x] withAnimation:^{
            [self cameraViewPosition:[self.class rightOfWindow]];
            [self localesViewPosition:[self.class inWindow]];
        }
    ];
}

#pragma mark - 
#pragma mark Locales To Camera

- (void)transitionLocalesToCamera {
    [self transition:[self horizontalTransitionDuration:self.localesViewController.view.frame.origin.x] withAnimation:^{
        [self cameraViewPosition:[self.class inWindow]];
        [self localesViewPosition:[self.class leftOfWindow]];
    }
     ];
}

- (void)releaseLocales {
    [self transition:[self horizontaltReleaseDuration:self.localesViewController.view.frame.origin.x] withAnimation:^{
            [self localesViewPosition:[self.class inWindow]];
        }
    ];    
}

- (void)dragLocales:(CGPoint)_drag {
    [self drag:_drag view:self.localesViewController.view];
}

#pragma mark - 
#pragma mark Camera To Inspect Image

- (void)transitionCameraToInspectImage {
    if ([self.imageInspectViewController hasCaptures]) {
        [self transition:[self verticalTransitionDuration:self.cameraViewController.view.frame.origin.y] withAnimation:^{
                [self cameraViewPosition:[self.class underWindow]];
                [self imageInspectViewPosition:[self.class inWindow]];
            }
        ];
    }
}

- (void)dragCameraToInspectImage:(CGPoint)_drag {
    if ([self.imageInspectViewController hasCaptures]) {
        [self drag:_drag view:self.cameraViewController.view];
    }
}

#pragma mark - 
#pragma mark Inspect Image To Camera

- (void)transitionInspectImageToCamera {
    [self transition:[self verticalTransitionDuration:self.imageInspectViewController.view.frame.origin.y] withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self imageInspectViewPosition:[self.class overWindow]];
        }
    ];    
}

- (void)releaseInspectImage {
    [self transition:[self verticalReleaseDuration:self.imageInspectViewController.view.frame.origin.y] withAnimation:^{
            [self imageInspectViewPosition:[self.class inWindow]];
        }
    ];    
}

- (void)dragInspectImage:(CGPoint)_drag {
    [self drag:_drag view:self.imageInspectViewController.view];
}

#pragma mark -
#pragma mark CameraViewControllerDelegate

- (void)didCaptureImage:(UIImage*)_picture { 
    [self.imageInspectViewController addImage:_picture];
    __block UIImageView* snapshot = [[UIImageView alloc] initWithImage:[_picture scaleImageToScreen]];
    [self.cameraViewController.view addSubview:snapshot];
    if (self.notAnimating) {
        self.notAnimating = NO;
        [UIView animateWithDuration:CAMERA_NEW_PHOTO_TRANSITION
            delay:CAMERA_NEW_PHOTO_DELAY
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                snapshot.frame = [self.class overWindow];
            }
            completion:^(BOOL _finished){
                [snapshot removeFromSuperview];
                self.notAnimating = YES;
            }
         ];
    }
}

@end
