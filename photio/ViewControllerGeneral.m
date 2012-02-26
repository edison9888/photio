//
//  ViewControllerGeneral.m
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ViewControllerGeneral.h"
#import "CameraViewController.h"
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

- (void)createViews:(UIView*)_containerView {
    [self createEntriesView:_containerView];
//    [self createImageInspectView:_containerView];
//    [self createCameraView:_containerView];
}

#pragma mark - 
#pragma mark EntriesViewController

- (EntriesViewController*)createEntriesView:(UIView*)_containerView {
    if (self.entriesViewController == nil) {
        self.entriesViewController = [EntriesViewController inView:_containerView];
    }
//    [self hideEntriesView];
    [self.entriesViewController viewWillAppear:NO];
    [_containerView addSubview:self.entriesViewController.view];
    return self.entriesViewController;
}

- (void)hideEntriesView {
    if (self.entriesViewController) {
        self.entriesViewController.view.hidden = YES;
    }
}

- (void)showEntriesView {
    if (self.entriesViewController) {
        self.entriesViewController.view.hidden = NO;
    }
}

#pragma mark - 
#pragma mark ImageInspectViewController

- (ImageInspectViewController*)createImageInspectView:(UIView*)_containerView {
    if (self.imageInspectViewController == nil) {
        self.imageInspectViewController = [ImageInspectViewController inView:_containerView];
    } 
    [self hideImageInspectView];
    [self.imageInspectViewController viewWillAppear:NO];
    [_containerView addSubview:self.imageInspectViewController.view];
    return self.imageInspectViewController;
}

- (void)hideImageInspectView {
    if (self.imageInspectViewController) {
        self.imageInspectViewController.view.hidden = YES;
    }
}

- (void)showImageInspectView {
    if (self.imageInspectViewController) {
        self.imageInspectViewController.view.hidden = NO;
    }
}

#pragma mark - 
#pragma mark CameraViewController

- (CameraViewController*)createCameraView:(UIView*)_containerView {
    if (self.cameraViewController == nil) {
        self.cameraViewController = [CameraViewController inView:_containerView];
    } 
//    [self hideCameraView];
    [self.cameraViewController viewWillAppear:YES];
    [_containerView addSubview:self.cameraViewController.imagePickerController.view];
    [self.cameraViewController viewDidAppear:YES];
    return self.cameraViewController;
}

- (void)hideCameraView {
    if (self.imageInspectViewController) {
        self.imageInspectViewController.view.hidden = YES;
    }
}

- (void)showCameraView {
    if (self.imageInspectViewController) {
        self.imageInspectViewController.view.hidden = NO;
    }
}

#pragma mark - 
#pragma mark Transitions
- (void)transitionEntriesToCamera; {
    [self hideEntriesView];
    [self showCameraView];
}


@end
