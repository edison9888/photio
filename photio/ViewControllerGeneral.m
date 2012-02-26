//
//  ViewControllerGeneral.m
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ViewControllerGeneral.h"
#import "ImageInspectViewController.h"
#import "EntriesViewController.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ViewControllerGeneral* thisViewControllerGeneral = nil;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewControllerGeneral (PrivateAPI)

@end

//-----------------------------------------------------------------------------------------------------------------------------------
@implementation ViewControllerGeneral
 
@synthesize imageInspectViewController, cameraViewController, entriesViewController;
@synthesize capture;

#pragma mark - 
#pragma mark ViewControllerGeneral PrivateApi

#pragma mark - 
#pragma mark ViewControllerGeneral PrivateApi

+ (ViewControllerGeneral*)instance {	
    @synchronized(self) {
        if (thisViewControllerGeneral == nil) {
            thisViewControllerGeneral = [[self alloc] init]; 
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

#pragma mark - 
#pragma mark EntriesViewController

- (void)initEntriesView:(UIView*)_containerView {
    if (self.entriesViewController == nil) {
        self.entriesViewController = [EntriesViewController inView:_containerView];
    }
    [self entriesViewPosition:[self.class underWindow]];
    [self.entriesViewController viewWillAppear:NO];
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
    [self.imageInspectViewController viewWillAppear:NO];
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
    [self.cameraViewController viewWillAppear:NO];
    [_containerView addSubview:self.cameraViewController.imagePickerController.view];
    [self.cameraViewController viewDidAppear:NO];
}

- (void)camerViewHidden:(BOOL)_hidden {
    self.cameraViewController.imagePickerController.view.hidden = _hidden;
}

- (void)cameraViewPosition:(CGRect)_rect {
    self.cameraViewController.imagePickerController.view.frame = _rect;
}

#pragma mark - 
#pragma mark Transitions
- (void)transitionEntriesToCamera {
    [UIView animateWithDuration:0.75
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction
        animations:^{
            [self cameraViewPosition:[self.class inWindow]];
            [self entriesViewPosition:[self.class underWindow]];
        }
        completion:^(BOOL _finished){
        }];
}

#pragma mark -
#pragma mark OverlayControllerDelegate

- (void)didTakePicture:(UIImage*)picture { 
    self.capture = picture;
}

- (void)didFinishWithCamera { 
//    [self dismissModalViewControllerAnimated:YES];
//    UIImageWriteToSavedPhotosAlbum(self.capture, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
//    UIImage* saveImage = [self.capture scaleBy:SAVED_IMAGE_SCALE andCropToSize:SAVED_IMAGE_CROP];
//    NSString* pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
//    [UIImagePNGRepresentation(saveImage) writeToFile:pngPath atomically:YES];
//    self.imageView.image = saveImage;
//    [self.view addSubview:imageView];        
}

@end
