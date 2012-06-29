//
//  ViewGeneral.h
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilteredCameraViewController.h"
#import "ImageInspectViewController.h"

@class ImageInspectViewController;
@class CalendarViewController;
@class LocalesViewController;
@class ProgressView;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewGeneral : NSObject <FilteredCameraViewControllerDelegate, ImageInspectViewControllerDelegate> {
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property(nonatomic, assign) BOOL                           notAnimating;
@property(nonatomic, strong) UIView*                        containerView;
@property(nonatomic, strong) ImageInspectViewController*    imageInspectViewController;
@property(nonatomic, strong) CalendarViewController*        calendarViewController;
@property(nonatomic, strong) LocalesViewController*         localesViewController;
@property(nonatomic, strong) FilteredCameraViewController*  cameraViewController;
@property(nonatomic, strong) ProgressView*                  progressView;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewGeneral*)instance;
+ (CGRect)screenBounds;
+ (CGRect)inWindow;
+ (CGRect)overWindow;
+ (CGRect)underWindow;
+ (CGRect)leftOfWindow;
+ (CGRect)rightOfWindow;
+ (void)alertOnError:(NSError*)error;

- (void)createViews:(UIView*)_containerView;
- (CGRect)calendarImageThumbnailRect;
- (void)updateCalendarEntryWithDate:(NSDate*)_date;
- (void)addCapture:(Capture*)_capture;

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)showProgressViewWithMessage:(NSString*)_progressMessage;
- (void)removeProgressView;

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

@end
