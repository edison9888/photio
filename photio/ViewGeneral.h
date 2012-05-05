//
//  ViewGeneral.h
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"
#import "ImageInspectViewController.h"

@class CameraViewController;
@class ImageInspectViewController;
@class CalendarViewController;
@class LocalesViewController;
@class ImageEditViewController;


//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewGeneral : NSObject <CameraViewControllerDelegate, ImageInspectViewControllerDelegate> {
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property(nonatomic, assign) BOOL                           notAnimating;
@property(nonatomic, strong) UIView*                        containerView;
@property(nonatomic, strong) UIView*                        shutter;
@property(nonatomic, strong) NSManagedObjectContext*        managedObjectContext;
@property(nonatomic, strong) ImageInspectViewController*    imageInspectViewController;
@property(nonatomic, strong) CameraViewController*          cameraViewController;
@property(nonatomic, strong) CalendarViewController*        calendarViewController;
@property(nonatomic, strong) LocalesViewController*         localesViewController;
@property(nonatomic, strong) ImageEditViewController*       imageEditViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewGeneral*)instance;
+ (CGRect)screenBounds;
+ (CGRect)inWindow;
+ (CGRect)overWindow;
+ (CGRect)underWindow;
+ (CGRect)leftOfWindow;
+ (CGRect)rightOfWindow;
- (void)createViews:(UIView*)_containerView;
- (void)saveManagedObjectContext;
- (NSArray*)fetchFromManagedObjectContext:(NSFetchRequest*)_fetchRequest;
- (void)openShutter;

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
- (void)initImageEditView:(UIView*)_containerView;
- (void)imageEditViewPosition:(CGRect)_rec;
- (void)imageEditViewHidden:(BOOL)_hidden;

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
