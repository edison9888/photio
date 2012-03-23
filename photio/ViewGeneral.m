//
//  ViewGeneral.m
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
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

@end

//-----------------------------------------------------------------------------------------------------------------------------------
@implementation ViewGeneral
 
@synthesize imageInspectViewController, cameraViewController, entryViewController, calendarViewController, localesViewController;
@synthesize captures;

#pragma mark - 
#pragma mark ViewGeneral PrivateApi

- (void)transition:(CGFloat)_duration withAnimation:(void(^)(void))_animation {
    [UIView animateWithDuration:_duration
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionFlipFromLeft
        animations:_animation
        completion:^(BOOL _finished){
        }
    ];
}

#pragma mark - 
#pragma mark ViewGeneral PrivateApi

+ (ViewGeneral*)instance {	
    @synchronized(self) {
        if (thisViewControllerGeneral == nil) {
            thisViewControllerGeneral = [[self alloc] init]; 
            thisViewControllerGeneral.captures = [NSMutableArray arrayWithCapacity:10];
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
    return CGRectMake(screenBounds.origin.x, -screenBounds.size.height, screenBounds.size.width, screenBounds.size.height);
}

+ (CGRect)underWindow {
    CGRect screenBounds = [self screenBounds];
    return CGRectMake(screenBounds.origin.x, screenBounds.size.height, screenBounds.size.width, screenBounds.size.height);
}

+ (CGRect)leftOfWindow {
    CGRect screenBounds = [self screenBounds];
    return CGRectMake(-screenBounds.size.width, screenBounds.origin.y, screenBounds.size.width, screenBounds.size.height);
}

+ (CGRect)rightOfWindow {
    CGRect screenBounds = [self screenBounds];
    return CGRectMake(screenBounds.size.width, screenBounds.origin.y, screenBounds.size.width, screenBounds.size.height);
}

+ (void)drag:(CGPoint)_drag view:(UIView*)_view {
    _view.transform = CGAffineTransformTranslate(_view.transform, _drag.x, _drag.y);
}

- (void)createViews:(UIView*)_containerView {
    [self initEntryView:_containerView];
    [self initCameraView:_containerView];
    [self initImageInspectView:_containerView];
    [self initCalendarView:_containerView];
    [self initLocalesView:_containerView];
}

- (BOOL)hasCaptures {
    return [self.captures count] != 0;
}

+ (UIImage*)scaleImageTScreen:(UIImage*)_capture {
    CGSize imageSize = _capture.size;
    CGRect screenBounds = [self.class screenBounds];
    CGFloat scaleImage = screenBounds.size.height / imageSize.height;
    return [_capture scaleBy:scaleImage andCropToSize:screenBounds.size];
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
    self.cameraViewController.cameraDelegate = self;
    [_containerView addSubview:self.cameraViewController.imagePickerController.view];
}

- (void)cameraViewHidden:(BOOL)_hidden {
    self.cameraViewController.imagePickerController.view.hidden = _hidden;
}

- (void)cameraViewPosition:(CGRect)_rect {
    self.cameraViewController.imagePickerController.view.frame = _rect;
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
    CGFloat delta = abs(self.cameraViewController.imagePickerController.view.frame.origin.x)/[self.class screenBounds].size.width;
    if ([CameraViewController cameraIsAvailable]) {
        [self.cameraViewController setFlashImage];
        [self transition:delta * TRANSITION_ANIMATION_DURATION withAnimation:^{
                [self cameraViewPosition:[self.class inWindow]];
                [self calendarViewPosition:[self.class rightOfWindow]];
            }
        ];    
    }
}

- (void)releaseCalendarToCamera {
    CGFloat delta = abs(self.cameraViewController.imagePickerController.view.frame.origin.x)/[self.class screenBounds].size.width;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class leftOfWindow]];
            [self calendarViewPosition:[self.class inWindow]];
        }
    ];    
}

- (void)dragCalendarToCamera:(CGPoint)_drag {
    [self.class drag:_drag view:self.cameraViewController.imagePickerController.view];
    [self.class drag:_drag view:self.calendarViewController.view];
}

#pragma mark - 
#pragma mark Camera To Calendar

- (void)transitionCameraToCalendar {
    CGFloat screenWidth = [self.class screenBounds].size.width;
    CGFloat delta = abs(screenWidth + self.cameraViewController.imagePickerController.view.frame.origin.x)/screenWidth;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class leftOfWindow]];
            [self calendarViewPosition:[self.class inWindow]];
        }
    ];
}

- (void)releaseCameraToCalendar {
    CGFloat screenWidth = [self.class screenBounds].size.width;
    CGFloat delta = abs(screenWidth + self.cameraViewController.imagePickerController.view.frame.origin.x)/screenWidth;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self calendarViewPosition:[self.class rightOfWindow]];
        }
    ];    
}

- (void)dragCameraToCalendar:(CGPoint)_drag {
    [self.class drag:_drag view:self.cameraViewController.imagePickerController.view];
    [self.class drag:_drag view:self.calendarViewController.view];
}

#pragma mark - 
#pragma mark Camera To Locales

- (void)transitionCameraToLocales {
    CGFloat screenWidth = [self.class screenBounds].size.width;
    CGFloat delta = abs(screenWidth - self.cameraViewController.imagePickerController.view.frame.origin.x)/screenWidth;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class rightOfWindow]];
            [self localesViewPosition:[self.class inWindow]];
        }
    ];
}

- (void)releaseCameraToLocales {
    CGFloat screenWidth = [self.class screenBounds].size.width;
    CGFloat delta = abs(screenWidth - self.cameraViewController.imagePickerController.view.frame.origin.x)/screenWidth;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self localesViewPosition:[self.class leftOfWindow]];
        }
    ];    
}

- (void)dragCameraToLocales:(CGPoint)_drag {
    [self.class drag:_drag view:self.localesViewController.view];
    [self.class drag:_drag view:self.cameraViewController.imagePickerController.view];
}

#pragma mark - 
#pragma mark Locales To Camera

- (void)transitionLocalesToCamera {
    CGFloat screenWidth = [self.class screenBounds].size.width;
    CGFloat delta = abs(screenWidth + self.localesViewController.view.frame.origin.x)/screenWidth;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
        [self cameraViewPosition:[self.class inWindow]];
        [self localesViewPosition:[self.class leftOfWindow]];
    }
     ];
}

- (void)releaseLocalesToCamera {
    CGFloat screenWidth = [self.class screenBounds].size.width;
    CGFloat delta = abs(screenWidth + self.localesViewController.view.frame.origin.x)/screenWidth;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
        [self cameraViewPosition:[self.class rightOfWindow]];
        [self localesViewPosition:[self.class inWindow]];
    }
     ];    
}

- (void)dragLocalesToCamera:(CGPoint)_drag {
    [self.class drag:_drag view:self.localesViewController.view];
    [self.class drag:_drag view:self.cameraViewController.imagePickerController.view];
}

#pragma mark - 
#pragma mark Camera To Inspect Image

- (void)transitionCameraToInspectImage {
    CGFloat screenHeight = [self.class screenBounds].size.height;
    CGFloat delta = abs(screenHeight + self.imageInspectViewController.view.frame.origin.y)/screenHeight;
    [self transition:delta * TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class underWindow]];
            [self imageInspectViewPosition:[self.class inWindow]];
        }
    ];    
}

- (void)releaseCameraToInspectImage {
    CGFloat screenHeight = [self.class screenBounds].size.height;
    CGFloat delta = abs(screenHeight + self.imageInspectViewController.view.frame.origin.y)/screenHeight;
    [self transition:delta * TRANSITION_ANIMATION_DURATION withAnimation:^{
        [self cameraViewPosition:[self.class inWindow]];
        [self imageInspectViewPosition:[self.class overWindow]];
    }
     ];    
}

- (void)dragCameraToInspectImage:(CGPoint)_drag {
    [self.class drag:_drag view:self.imageInspectViewController.view];
    [self.class drag:_drag view:self.cameraViewController.imagePickerController.view];
}


#pragma mark - 
#pragma mark Inspect Image To Camera

- (void)transitionInspectImageToCamera {
    CGFloat delta = self.cameraViewController.imagePickerController.view.frame.origin.y / [self.class screenBounds].size.height;
    [self transition:delta * TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self imageInspectViewPosition:[self.class overWindow]];
        }
    ];    
}

- (void)releaseInspectImageToCamera {
    CGFloat delta = self.cameraViewController.imagePickerController.view.frame.origin.y / [self.class screenBounds].size.height;
    [self transition:delta * TRANSITION_ANIMATION_DURATION withAnimation:^{
        [self cameraViewPosition:[self.class underWindow]];
        [self imageInspectViewPosition:[self.class inWindow]];
    }
     ];    
}

- (void)dragInspectImageToCamera:(CGPoint)_drag {
    [self.class drag:_drag view:self.imageInspectViewController.view];
    [self.class drag:_drag view:self.cameraViewController.imagePickerController.view];
}


#pragma mark -
#pragma mark CameraViewControllerDelegate

- (void)didTakePicture:(UIImage*)_picture { 
    [self.captures addObject:_picture];
    __block UIImageView* snapshot = [[UIImageView alloc] initWithImage:[self.class scaleImageTScreen:_picture]];
    [self.cameraViewController.imagePickerController.view addSubview:snapshot];
    [UIView animateWithDuration:CAMERA_NEW_PHOTO_TRANSITION
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionCurlUp
        animations:^{
            snapshot.frame = [self.class overWindow];
        }
        completion:^(BOOL _finished){
            [snapshot removeFromSuperview];
        }
     ];

}

- (void)didFinishWithCamera {
    [self.imageInspectViewController loadCaptures:self.captures];
    [self transitionCameraToInspectImage];
}

@end
