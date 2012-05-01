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
#import "ImageInspectView.h"
#import "Capture.h"
#import "Image.h"

#import "CalendarViewController.h"
#import "LocalesViewController.h"

#define HORIZONTAL_TRANSITION_ANIMATION_SPEED           500.0f
#define VERTICAL_TRANSITION_ANIMATION_SPEED             600.0f
#define RELEASE_ANIMATION_SPEED                         150.0f
#define VIEW_MIN_SPACING                                25
#define SAVE_IMAGE_DELAY                                0.65f

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
- (void)saveImageLater:(ImageInspectView*)_imageInspectView;

@end

//-----------------------------------------------------------------------------------------------------------------------------------
@implementation ViewGeneral
 
@synthesize notAnimating, managedObjectContext, containerView;
@synthesize imageInspectViewController, cameraViewController, calendarViewController, localesViewController;

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
    return (screenBounds.size.height - abs(_offset)) / VERTICAL_TRANSITION_ANIMATION_SPEED;    
}

- (CGFloat)horizontalTransitionDuration:(CGFloat)_offset {
    CGRect screenBounds = [self.class screenBounds];
    return (screenBounds.size.width  - abs(_offset)) / HORIZONTAL_TRANSITION_ANIMATION_SPEED;    
}

- (void)saveImageToPhotoAlbum:(UIImage*)_image {
    ALAssetsLibrary* library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:[_image CGImage] orientation:(ALAssetOrientation)[_image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){}];
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

- (void)createViews:(UIView*)_containerView {
    self.containerView = _containerView;
    [self initImageInspectView:_containerView];
    [self initCameraView:_containerView];
    [self initCalendarView:_containerView];
    [self initLocalesView:_containerView];
}

- (void)saveManagedObjectContext {
    NSError *error = nil;
    if (![[ViewGeneral instance].managedObjectContext save:&error]) {
        [[[UIAlertView alloc] initWithTitle:@"Database Error" message:@"There was an error updating the database" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    }
}

- (NSArray*)fetchFromManagedObjectContext:(NSFetchRequest*)_fetchRequest {
    NSError* error;
    NSArray* fetchResults = [[ViewGeneral instance].managedObjectContext executeFetchRequest:_fetchRequest error:&error];
    if (fetchResults == nil) {
        [[[UIAlertView alloc] initWithTitle:@"Database Error" message:@"There was an error in retrieving data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        abort();
    }
    return fetchResults;
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
    [self.cameraViewController continouslyAutoFocus];
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
    [self.cameraViewController continouslyAutoFocus];
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
#pragma mark CameraViewControllerDelegate

- (void)didCaptureImage:(UIImage*)_picture { 
    if (self.notAnimating) {
        self.notAnimating = NO;
        [self.imageInspectViewController addImage:_picture];
    }
}

- (void)didDragCameraRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity{
    [self dragCamera:_drag];    
}

- (void)didDragCameraLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragCamera:_drag];
}

- (void)didDragCameraDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragCameraToInspectImage:_drag];
}

- (void)didReleaseCameraRight:(CGPoint)_location {
    [self releaseCamera];
}

- (void)didReleaseCameraLeft:(CGPoint)_location {
    [self releaseCamera];
}

- (void)didReleaseCameraDown:(CGPoint)_location {
    [self releaseCameraInspectImage];
}

- (void)didSwipeCameraRight:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self transitionCameraToLocales];    
}

- (void)didSwipeCameraLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self transitionCameraToCalendar];    
}

- (void)didSwipeCameraDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self transitionCameraToInspectImage];
}

- (void)didReachCameraMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self transitionCameraToLocales];    
}

- (void)didReachCameraMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self transitionCameraToCalendar];    
}

- (void)didReachCameraMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self transitionCameraToInspectImage];
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
    [self.cameraViewController continouslyAutoFocus];
    [self transition:[self verticalTransitionDuration:self.imageInspectViewController.view.frame.origin.y] withAnimation:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self imageInspectViewPosition:[self.class overWindow]];
        }
    ];    
}

- (void)saveImage:(ImageInspectView*)_imageInspectView {
    [self performSelector:@selector(saveImageLater:) withObject:_imageInspectView afterDelay:SAVE_IMAGE_DELAY];
}

- (void)saveImageLater:(ImageInspectView*)_imageInspectView {
    Capture* capture = (Capture*)[NSEntityDescription insertNewObjectForEntityForName:@"Capture" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
    capture.latitude  = _imageInspectView.latitude;
    capture.longitude = _imageInspectView.longitude;
    capture.createdAt = _imageInspectView.createdAt;
    capture.dayIdentifier = [self.calendarViewController dayIdentifier:_imageInspectView.createdAt];
    capture.thumbnail = [_imageInspectView.capture thumbnailImage:[self.calendarViewController calendarImageThumbnailRect].size.width];
    Image* image = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
	image.image = _imageInspectView.capture;
	capture.image = image;
    [self saveManagedObjectContext];
    [self.calendarViewController updateLatestCapture];
}

@end
