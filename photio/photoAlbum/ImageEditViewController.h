//
//  ImageEditViewController.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreamOfViews.h"
#import "ImageMetaDataEditView.h"
#import "ImageEditView.h"

@protocol ImageEditViewControllerDelegate;
@class Capture;

@interface ImageEditViewController : UIViewController <StreamOfViewsDelegate, ImageEditViewDelegate, ImageMetaDataEditViewDelegate, UIGestureRecognizerDelegate>

@property(nonatomic, weak)   id<ImageEditViewControllerDelegate>    delegate;
@property(nonatomic, strong) StreamOfViews*                         streamView;
@property(nonatomic, strong) UIView*                                containerView;
@property(nonatomic, strong) ImageMetaDataEditView*                 imageMetaDataEditView;
@property(nonatomic, strong) ImageEditView*                         imageEditView;
@property(nonatomic, strong) Capture*                               capture;
@property(nonatomic, strong) IBOutlet UIGestureRecognizer*          removeGesture;
@property(nonatomic, strong) IBOutlet UIGestureRecognizer*          singleTapGesture;

+ (id)inView:(UIView*)_containerView withDelegate:(id<ImageEditViewControllerDelegate>)_delegate andCapture:(Capture*)_capture;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil inView:(UIView*)_containerView delegate:(id<ImageEditViewControllerDelegate>)_delegate andCapture:(Capture*)_capture;
- (void)showViews;
- (void)hideViews;


@end

@protocol ImageEditViewControllerDelegate <NSObject>

@optional

- (void)singleTapImageEditGesture;

@required

- (void)applyFilter:(Filter*)_filter withValue:(NSNumber*)_value;
- (void)saveFilteredImage:(Filter*)_filter withValue:(NSNumber*)_value;
- (void)resetFilteredImage;

@end