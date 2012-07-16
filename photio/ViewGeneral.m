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
#import "Capture.h"
#import "CaptureManager.h"
#import "ImageDisplay.h"

#import "ImageEditViewController.h"
#import "CalendarViewController.h"
#import "AlbumsViewController.h"
#import "ProgressView.h"

#define HORIZONTAL_TRANSITION_ANIMATION_SPEED           500.0f
#define VERTICAL_TRANSITION_ANIMATION_SPEED             600.0f
#define RELEASE_ANIMATION_SPEED                         150.0f
#define VIEW_MIN_SPACING                                25
#define SAVE_IMAGE_DELAY                                0.65f
#define OPEN_SHUTTER_TRANSITION                         0.25
#define OPEN_SHUTTER_DELAY                              1.0
#define MAX_COMMENT_LINES                               5
#define COMMENT_YOFFSET                                 15


/////////////////////////////////////////////////////////////////////////////////////////
static ViewGeneral* thisViewControllerGeneral = nil;

/////////////////////////////////////////////////////////////////////////////////////////
@interface ViewGeneral (PrivateAPI)

- (void)transition:(CGFloat)_duration withAnimation:(void(^)(void))_animation;
- (void)drag:(CGPoint)_drag view:(UIView*)_view;
- (CGFloat)verticalReleaseDuration:(CGFloat)_offset;
- (CGFloat)horizontaltReleaseDuration:(CGFloat)_offset;
- (CGFloat)verticalTransitionDuration:(CGFloat)_offset;
- (CGFloat)horizontalTransitionDuration:(CGFloat)_offset;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation ViewGeneral
 
@synthesize notAnimating, containerView;
@synthesize imageInspectViewController, cameraViewController, calendarViewController, albumsViewController,
            progressView;

#pragma mark - 
#pragma mark ViewGeneral PrivateAPI

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
    return (screenBounds.size.height - abs(_offset)) / VERTICAL_TRANSITION_ANIMATION_SPEED;    
}

- (CGFloat)horizontalTransitionDuration:(CGFloat)_offset {
    CGRect screenBounds = [self.class screenBounds];
    return (screenBounds.size.width  - abs(_offset)) / HORIZONTAL_TRANSITION_ANIMATION_SPEED;    
}

#pragma mark - 
#pragma mark ViewGeneral

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

+ (void)alertOnError:(NSError*)error {
    NSLog(@"Had and Error %@, %@", error, [error userInfo]);
    [[[UIAlertView alloc] initWithTitle:[error localizedDescription] message:[error localizedFailureReason] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title") otherButtonTitles:nil] show];    
}

+ (CGRect)imageThumbnailRect {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width / THUMBNAILS_IN_ROW;
    return CGRectMake(0.0, 0.0, width, width);
}

- (void)createViews:(UIView*)_containerView {
    self.containerView = _containerView;
    [self initImageInspectView:_containerView];
    [self initCameraView:_containerView];
    [self initCalendarView:_containerView];
//    [self initAlbumsView:_containerView];
}

- (void)updateCalendarEntryWithDate:(NSDate*)_date {
    [self.calendarViewController updateEntryWithDate:_date];
}

- (void)addCapture:(Capture*)_capture {
    [self.imageInspectViewController addCapture:_capture];
}

#pragma mark - 
#pragma mark ProgressView

- (void)showProgressViewWithMessage:(NSString*)_progressMessage {
    if (self.progressView == nil) {
        self.progressView = [ProgressView progressView];
    }
    [self.progressView progressWithMessage:_progressMessage inView:self.containerView];
}

- (void)removeProgressView {
    [self.progressView remove]; 
}

#pragma mark - 
#pragma mark ImageInspectViewController

- (void)initImageInspectView:(UIView*)_containerView {
    if (self.imageInspectViewController == nil) {
        self.imageInspectViewController = [ImageInspectViewController inView:_containerView withDelegate:self];
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
        self.cameraViewController = [FilteredCameraViewController inView:_containerView];
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

#pragma mark - AlbumsViewController

- (void)initAlbumsView:(UIView*)_containerView {
    if (self.albumsViewController == nil) {
        self.albumsViewController = [AlbumsViewController inView:_containerView];
    } 
    [self albumsViewPosition:[self.class leftOfWindow]];
    [_containerView addSubview:self.albumsViewController.view];
}

- (void)albumsViewHidden:(BOOL)_hidden {
    self.albumsViewController.view.hidden = _hidden;
}

- (void)albumsViewPosition:(CGRect)_rect {
    self.albumsViewController.view.frame = _rect;
}

#pragma mark - 
#pragma mark Calendar To Camera

- (void)transitionCalendarToCamera {
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
#pragma mark Camera To Albums

- (void)transitionCameraToAlbums {
    [self transition:[self horizontalTransitionDuration:self.cameraViewController.view.frame.origin.x] withAnimation:^{
            [self cameraViewPosition:[self.class rightOfWindow]];
            [self albumsViewPosition:[self.class inWindow]];
        }
    ];
}

#pragma mark - 
#pragma mark Albums To Camera

- (void)transitionAlbumsToCamera {
    [self transition:[self horizontalTransitionDuration:self.albumsViewController.view.frame.origin.x] withAnimation:^{
        [self cameraViewPosition:[self.class inWindow]];
        [self albumsViewPosition:[self.class leftOfWindow]];
    }
     ];
}

- (void)releaseAlbums {
    [self transition:[self horizontaltReleaseDuration:self.albumsViewController.view.frame.origin.x] withAnimation:^{
            [self albumsViewPosition:[self.class inWindow]];
        }
    ];    
}

- (void)dragAlbums:(CGPoint)_drag {
    [self drag:_drag view:self.albumsViewController.view];
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

- (void)releaseCameraInspectImage {
    [self transition:[self horizontaltReleaseDuration:self.cameraViewController.view.frame.origin.y] withAnimation:^{
        [self cameraViewPosition:[self.class inWindow]];
    }
     ];    
}

- (void)dragCameraToInspectImage:(CGPoint)_drag {
    if ([self.imageInspectViewController hasCaptures]) {
        [self drag:_drag view:self.cameraViewController.view];
    }
}

#pragma mark -
#pragma mark ImageInspectViewControllerDelegate

- (void)dragInspectImage:(CGPoint)_drag {
    [self drag:_drag view:self.imageInspectViewController.view];
}

- (void)releaseInspectImage {
    [self transition:[self verticalReleaseDuration:self.imageInspectViewController.view.frame.origin.y] withAnimation:^{
            [self imageInspectViewPosition:[self.class inWindow]];
        }
    ];    
}

- (void)transitionFromInspectImage {
    [self transition:[self verticalTransitionDuration:self.imageInspectViewController.view.frame.origin.y] withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self imageInspectViewPosition:[self.class overWindow]];
        }
    ];    
}


@end
