//
//  ViewGeneral.h
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@class CameraViewController;
@class ImageInspectViewController;
@class EntryViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewGeneral : NSObject <CameraViewControllerDelegate> {
    CameraViewController*       cameraViewController;
    ImageInspectViewController* imageInspectViewController;
    EntryViewController*        entriesViewController;
    NSMutableArray*             captures;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property(nonatomic, retain) ImageInspectViewController*    imageInspectViewController;
@property(nonatomic, retain) CameraViewController*          cameraViewController;
@property(nonatomic, retain) EntryViewController*           entryViewController;
@property(nonatomic, retain) NSMutableArray*                captures;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewGeneral*)instance;
+ (CGRect)screenBounds;
+ (CGRect)inWindow;
+ (CGRect)overWindow;
+ (CGRect)underWindow;
+ (CGRect)leftOfWindow;
+ (CGRect)rightOfWindow; 
- (void)createViews:(UIView*)_containerView;
- (BOOL)hasCaptures;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initEntryView:(UIView*)_containerView;
- (void)entryViewPosition:(CGRect)_rect;
- (void)entryViewHidden:(BOOL)_hidden;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initImageInspectView:(UIView*)_containerView;
- (void)imageInspectViewPosition:(CGRect)_rec;
- (void)imageInspectViewHidden:(BOOL)_hidden;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initCameraView:(UIView*)_containerView;
- (void)cameraViewPosition:(CGRect)_rec;
- (void)cameraViewHidden:(BOOL)_hidden;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionEntryToCamera;
- (void)dragEntryToCamera:(CGPoint)_drag;
- (void)releaseEntryToCamera;

- (void)transitionCameraToEntry;
- (void)dragCameraToEntry:(CGPoint)_drag;
- (void)releaseCameraToEntry;

- (void)transitionCameraToInspectImage;

- (void)transitionInspectImageToCamera;

@end
