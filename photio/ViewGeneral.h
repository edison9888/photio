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
@class CalendarViewController;
@class LocalesViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewGeneral : NSObject <CameraViewControllerDelegate> {
    BOOL                        notAnimating;
    CameraViewController*       cameraViewController;
    ImageInspectViewController* imageInspectViewController;
    EntryViewController*        entriesViewController;
    CalendarViewController*     calendarViewController;
    LocalesViewController*      localesViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property(nonatomic, assign) BOOL                           notAnimating;
@property(nonatomic, retain) ImageInspectViewController*    imageInspectViewController;
@property(nonatomic, retain) CameraViewController*          cameraViewController;
@property(nonatomic, retain) EntryViewController*           entryViewController;
@property(nonatomic, retain) CalendarViewController*        calendarViewController;
@property(nonatomic, retain) LocalesViewController*         localesViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewGeneral*)instance;
+ (CGRect)screenBounds;
+ (CGRect)inWindow;
+ (CGRect)overWindow;
+ (CGRect)underWindow;
+ (CGRect)leftOfWindow;
+ (CGRect)rightOfWindow; 
- (void)createViews:(UIView*)_containerView;

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
- (void)initCalendarView:(UIView*)_containerView;
- (void)calendarViewPosition:(CGRect)_rec;
- (void)calendarViewHidden:(BOOL)_hidden;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)initLocalesView:(UIView*)_containerView;
- (void)localesViewPosition:(CGRect)_rec;
- (void)localesViewHidden:(BOOL)_hidden;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionCalendarToCamera;
- (void)releaseCalendar;
- (void)dragCalendar:(CGPoint)_drag;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionCameraToCalendar;
- (void)releaseCamera;
- (void)dragCamera:(CGPoint)_drag;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionCameraToLocales;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionLocalesToCamera;
- (void)releaseLocales;
- (void)dragLocales:(CGPoint)_drag;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionCameraToInspectImage;
- (void)releaseCameraInspectImage;
- (void)dragCameraToInspectImage:(CGPoint)_drag;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionInspectImageToCamera;
- (void)releaseInspectImage;
- (void)dragInspectImage:(CGPoint)_drag;

@end
