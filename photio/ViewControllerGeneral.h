//
//  ViewControllerGeneral.h
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@class CameraViewController;
@class ImageInspectViewController;
@class EntriesViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewControllerGeneral : NSObject <CameraViewControllerDelegate> {
    UIImage*                    capture;
    CameraViewController*       cameraViewController;
    ImageInspectViewController* imageInspectViewController;
    EntriesViewController*      entriesViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property(nonatomic, retain) UIImage*                       capture;
@property(nonatomic, retain) ImageInspectViewController*    imageInspectViewController;
@property(nonatomic, retain) CameraViewController*          cameraViewController;
@property(nonatomic, retain) EntriesViewController*         entriesViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewControllerGeneral*)instance;
+ (CGRect)screenBounds;
+ (CGRect)inWindow;
+ (CGRect)overWindow;
+ (CGRect)underWindow;
+ (CGRect)leftOfWindow;
+ (CGRect)rightOfWindow; 
- (void)createViews:(UIView*)_containerView;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initEntriesView:(UIView*)_containerView;
- (void)entriesViewPosition:(CGRect)_rect;
- (void)entriesViewHidden:(BOOL)_hidden;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initImageInspectView:(UIView*)_containerView;
- (void)imageInspectViewPosition:(CGRect)_rec;
- (void)imageInspectViewHidden:(BOOL)_hidden;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initCameraView:(UIView*)_containerView;
- (void)cameraViewPosition:(CGRect)_rec;
- (void)cameraViewHidden:(BOOL)_hidden;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionEntriesToCamera;

@end
