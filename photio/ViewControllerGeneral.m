//
//  ViewControllerGeneral.m
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ViewControllerGeneral.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ViewControllerGeneral* thisViewControllerGeneral = nil;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewControllerGeneral (PrivateAPI)

@end

//-----------------------------------------------------------------------------------------------------------------------------------
@implementation ViewControllerGeneral
 
@synthesize imageInspectViewController, cameraViewController;

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

#pragma mark - 
#pragma mark CameraViewController

- (CameraViewController*)showCameraView:(UIView*)_containerView {
    if (self.cameraViewController == nil) {
        self.cameraViewController = [CameraViewController inView:_containerView];
    } 
    [self.cameraViewController viewWillAppear:YES];
    [_containerView addSubview:self.cameraViewController.imagePickerController.view];
    [self.cameraViewController viewDidAppear:YES];
    return self.cameraViewController;
}

- (void)removeCameraView {
    if (self.cameraViewController) {
        [self.cameraViewController viewWillDisappear:YES];
        [self.cameraViewController.view removeFromSuperview];
    }
}


#pragma mark - 
#pragma mark ImageInspectViewController

- (ImageInspectViewController*)showImageInspectView:(UIView*)_containerView {
    if (self.imageInspectViewController == nil) {
        self.imageInspectViewController = [ImageInspectViewController inView:_containerView];
    } 
    [_containerView addSubview:self.imageInspectViewController.view];
    [self.imageInspectViewController viewWillAppear:NO];
    return self.imageInspectViewController;
}

- (void)removeImageInspectView {
    if (self.imageInspectViewController) {
        [self.imageInspectViewController viewWillDisappear:NO];
        [self.imageInspectViewController.view removeFromSuperview];
    }
}

@end
