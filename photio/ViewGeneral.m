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

//-----------------------------------------------------------------------------------------------------------------------------------
static ViewGeneral* thisViewControllerGeneral = nil;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewGeneral (PrivateAPI)

@end

//-----------------------------------------------------------------------------------------------------------------------------------
@implementation ViewGeneral
 
@synthesize imageInspectViewController, cameraViewController, entryViewController;
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

- (void)createViews:(UIView*)_containerView {
    [self initEntryView:_containerView];
    [self initImageInspectView:_containerView];
    [self initCameraView:_containerView];
}

- (BOOL)hasCaptures {
    return [self.captures count] != 0;
}

#pragma mark - 
#pragma mark EntriesViewController

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
    [self imageInspectViewPosition:[self.class rightOfWindow]];
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
    [self cameraViewPosition:[self.class overWindow]];
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
#pragma mark Entry To Camera

- (void)transitionEntryToCamera {
    [self.cameraViewController setFlashImage];
    if ([CameraViewController cameraIsAvailable]) {
        [self transition:TRANSITION_ANIMATION_DURATION withAnimation:^{
                [self cameraViewPosition:[self.class inWindow]];
                [self entryViewPosition:[self.class underWindow]];
            }
        ];    
    }
}

- (void)dragEntryToCamera:(CGPoint)_drag {
    CGRect newFrame = self.cameraViewController.imagePickerController.view.frame;
    newFrame.origin.x -= _drag.x;
    newFrame.origin.y -= _drag.y;
    self.cameraViewController.imagePickerController.view.frame = newFrame;
    newFrame = self.entryViewController.view.frame;
    newFrame.origin.x -= _drag.x;
    newFrame.origin.y -= _drag.y;
    self.entryViewController.view.frame = newFrame;
}

- (void)releaseEntryToCamera {
    CGFloat delta = abs(self.cameraViewController.imagePickerController.view.frame.origin.y)/[self.class screenBounds].size.height;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self entryViewPosition:[self.class underWindow]];
        }
    ];    
}

#pragma mark - 
#pragma mark Camera To Entry

- (void)transitionCameraToEntry {
    CGFloat delta = abs([self.class screenBounds].size.height + self.cameraViewController.imagePickerController.view.frame.origin.y)/[self.class screenBounds].size.height;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class overWindow]];
            [self entryViewPosition:[self.class inWindow]];
        }
    ];
}

- (void)dragCameraToEntry:(CGPoint)_drag {
    CGRect newFrame = self.cameraViewController.imagePickerController.view.frame;
    newFrame.origin.x += _drag.x;
    newFrame.origin.y += _drag.y;
    self.cameraViewController.imagePickerController.view.frame = newFrame;
    newFrame = self.entryViewController.view.frame;
    newFrame.origin.x += _drag.x;
    newFrame.origin.y += _drag.y;
    self.entryViewController.view.frame = newFrame;
}

- (void)releaseCameraToEntry {
    CGFloat delta = abs(self.cameraViewController.imagePickerController.view.frame.origin.y)/[self.class screenBounds].size.height;
    [self transition:delta*TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self entryViewPosition:[self.class underWindow]];
        }
    ];    
}

#pragma mark - 
#pragma mark Camera To Inspect Image

- (void)transitionCameraToInspectImage {
    [self transition:TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class overWindow]];
            [self imageInspectViewPosition:[self.class inWindow]];
        }
    ];    
}

#pragma mark - 
#pragma mark Inspect Image To Camera

- (void)transitionInspectImageToCamera {
    [self transition:TRANSITION_ANIMATION_DURATION withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self imageInspectViewPosition:[self.class rightOfWindow]];
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
