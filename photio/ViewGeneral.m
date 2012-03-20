//
//  ViewGeneral.m
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewGeneral.h"
#import "ImageInspectViewController.h"
#import "EntryViewController.h"
#import "CalendarViewController.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ViewGeneral* thisViewControllerGeneral = nil;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewGeneral (PrivateAPI)

@end

//-----------------------------------------------------------------------------------------------------------------------------------
@implementation ViewGeneral
 
@synthesize imageInspectViewController, cameraViewController, entryViewController, calendarViewController;
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
}

- (BOOL)hasCaptures {
    return [self.captures count] != 0;
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
    CGFloat screenHeight = [self.class screenBounds].size.height;
    CGFloat delta = abs(screenHeight + self.cameraViewController.imagePickerController.view.frame.origin.y)/screenHeight;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class leftOfWindow]];
            [self calendarViewPosition:[self.class inWindow]];
        }
    ];
}

- (void)releaseCameraToCalendar {
    CGFloat delta = abs(self.cameraViewController.imagePickerController.view.frame.origin.x)/[self.class screenBounds].size.width;
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
#pragma mark Camera To Inspect Image

- (void)transitionCameraToInspectImage {
    [self transition:TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class underWindow]];
            [self imageInspectViewPosition:[self.class inWindow]];
        }
    ];    
}

#pragma mark - 
#pragma mark Inspect Image To Camera

- (void)transitionInspectImageToCamera {
    [self transition:TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self imageInspectViewPosition:[self.class overWindow]];
        }
    ];    
}

#pragma mark -
#pragma mark OverlayControllerDelegate

- (void)didTakePicture:(UIImage*)picture { 
    [self.captures addObject:picture];
    [self didFinishWithCamera];
}

- (void)didFinishWithCamera {
    [self.imageInspectViewController loadCaptures:self.captures];
    [self transitionCameraToInspectImage];
}

@end
