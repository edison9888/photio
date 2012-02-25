//
//  ViewControllerGeneral.h
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraViewController;
@class ImageInspectViewController;
@class EntriesViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewControllerGeneral : NSObject {
    CameraViewController*       cameraViewController;
    ImageInspectViewController* imageInspectViewController;
    EntriesViewController*      entriesViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property(nonatomic, retain) ImageInspectViewController*    imageInspectViewController;
@property(nonatomic, retain) CameraViewController*          cameraViewController;
@property(nonatomic, retain) EntriesViewController*         entriesViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewControllerGeneral*)instance;
- (void)createViews:(UIView*)_containerView;

//-----------------------------------------------------------------------------------------------------------------------------------
- (EntriesViewController*)createEntriesView:(UIView*)_containerView;
- (void)hideEntriesView;
- (void)showEntriesView;

//-----------------------------------------------------------------------------------------------------------------------------------
- (ImageInspectViewController*)createImageInspectView:(UIView*)_containerView;
- (void)hideImageInspectView;
- (void)showImageInspectView;

//-----------------------------------------------------------------------------------------------------------------------------------
- (CameraViewController*)createCameraView:(UIView*)_containerView;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionEntriesToImageInspect;

@end
