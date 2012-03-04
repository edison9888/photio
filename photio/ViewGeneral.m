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
#import "EntriesViewController.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ViewGeneral* thisViewControllerGeneral = nil;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewGeneral (PrivateAPI)

@end

//-----------------------------------------------------------------------------------------------------------------------------------
@implementation ViewGeneral
 
@synthesize imageInspectViewController, cameraViewController, entriesViewController;
@synthesize captures;

#pragma mark - 
#pragma mark ViewGeneral PrivateApi

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
    [self initEntriesView:_containerView];
    [self initImageInspectView:_containerView];
    [self initCameraView:_containerView];
}

- (BOOL)hasCaptures {
    return [self.captures count] != 0;
}

#pragma mark - 
#pragma mark EntriesViewController

- (void)initEntriesView:(UIView*)_containerView {
    if (self.entriesViewController == nil) {
        self.entriesViewController = [EntriesViewController inView:_containerView];
    }
    [self entriesViewPosition:[self.class underWindow]];
    [_containerView addSubview:self.entriesViewController.view];
}

- (void)entriesViewHidden:(BOOL)_hidden {
    self.entriesViewController.view.hidden = _hidden;
}

- (void)entriesViewPosition:(CGRect)_rect {
    self.entriesViewController.view.frame = _rect;
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
#pragma mark Entries To Camera

- (void)transitionEntriesToCamera {
    [self.cameraViewController setFlashImage];
    if ([CameraViewController cameraIsAvailable]) {
        [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION
            delay:0
            options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
            animations:^{
                [self cameraViewPosition:[self.class inWindow]];
                [self entriesViewPosition:[self.class underWindow]];
            }
            completion:^(BOOL _finished){
            }
        ];
    }
}

#pragma mark - 
#pragma mark Camera To Entries

- (void)transitionCameraToEntries {
    CGFloat delta = abs([self.class screenBounds].size.height + self.cameraViewController.imagePickerController.view.frame.origin.y)/[self.class screenBounds].size.height;
    [UIView animateWithDuration:delta*TRANSITION_ANIMATION_DURATION
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
        animations:^{
            [self cameraViewPosition:[self.class overWindow]];
            [self entriesViewPosition:[self.class inWindow]];
        }
        completion:^(BOOL _finished){
        }
    ];
}

- (void)dragCameraToEntries:(CGPoint)_drag {
    CGRect newFrame = self.cameraViewController.imagePickerController.view.frame;
    newFrame.origin.x += _drag.x;
    newFrame.origin.y += _drag.y;
    self.cameraViewController.imagePickerController.view.frame = newFrame;
    newFrame = self.entriesViewController.view.frame;
    newFrame.origin.x += _drag.x;
    newFrame.origin.y += _drag.y;
    self.entriesViewController.view.frame = newFrame;
}

- (void)releaseCameraToEntries {
    CGFloat delta = abs(self.cameraViewController.imagePickerController.view.frame.origin.y)/[self.class screenBounds].size.height;
    [UIView animateWithDuration:delta*TRANSITION_ANIMATION_DURATION
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
        animations:^{
             [self cameraViewPosition:[self.class inWindow]];
             [self entriesViewPosition:[self.class underWindow]];
        }
        completion:^(BOOL _finished){
        }
     ];    
}

- (void)transitionCameraToInspectImage {
    [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionFlipFromLeft
        animations:^{
            [self cameraViewPosition:[self.class overWindow]];
            [self imageInspectViewPosition:[self.class inWindow]];
        }
        completion:^(BOOL _finished){
        }
    ];
}

- (void)transitionInspectImageToCamera {
    [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionFlipFromLeft
        animations:^{
           [self cameraViewPosition:[self.class inWindow]];
           [self imageInspectViewPosition:[self.class rightOfWindow]];
        }
        completion:^(BOOL _finished){
        }
    ];
}

- (void)transitionInspectImageToEntries {
    [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionFlipFromLeft
        animations:^{
            [self entriesViewPosition:[self.class inWindow]];
            [self imageInspectViewPosition:[self.class rightOfWindow]];
        }
        completion:^(BOOL _finished){
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
