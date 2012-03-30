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
    CameraViewController*       cameraViewController;
    ImageInspectViewController* imageInspectViewController;
    EntryViewController*        entriesViewController;
    CalendarViewController*     calendarViewController;
    LocalesViewController*      localesViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
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
+ (void)drag:(CGPoint)_drag view:(UIView*)_view;
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
- (void)releaseCalendarToCamera;
- (void)dragCalendarToCamera:(CGPoint)_drag;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionCameraToCalendar;
- (void)releaseCameraToCalendar;
- (void)dragCameraToCalendar:(CGPoint)_drag;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionCameraToLocales;
- (void)releaseCameraToLocales;
- (void)dragCameraToLocales:(CGPoint)_drag;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionLocalesToCamera;
- (void)releaseLocalesToCamera;
- (void)dragLocalesToCamera:(CGPoint)_drag;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionCameraToInspectImage;
- (void)releaseCameraToInspectImage;
- (void)dragCameraToInspectImage:(CGPoint)_drag;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)transitionInspectImageToCamera;
- (void)releaseInspectImageToCamera;
- (void)dragInspectImageToCamera:(CGPoint)_drag;

@end
