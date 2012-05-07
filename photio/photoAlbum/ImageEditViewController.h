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

@interface ImageEditViewController : UIViewController <StreamOfViewsDelegate, ImageEditViewDelegate, ImageMetaDataEditViewDelegate>

@property(nonatomic, weak)   id<ImageEditViewControllerDelegate>    delegate;
@property(nonatomic, strong) StreamOfViews*                         streamView;
@property(nonatomic, strong) UIView*                                containerView;
@property(nonatomic, strong) ImageMetaDataEditView*                 imageMetaDataEditView;
@property(nonatomic, strong) ImageEditView*                         imageEditView;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil inView:(UIView*)_containerView;
- (void)updateComment:(NSString*)_comment;
- (void)updateRating:(NSString*)_rating;
- (IBAction)remove:(id)sender;

@end

@protocol ImageEditViewControllerDelegate <NSObject>

- (void)exportToCameraRoll;
- (void)saveComment:(NSString*)_comment;
- (void)saveRating:(NSString*)_rating;

@end