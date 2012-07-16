//
//  ImageEntryView.h
//  photio
//
//  Created by Troy Stribling on 4/5/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ImageEditViewController.h"

@protocol ImageEntryViewDelegate;

@class Capture;
@class ImageEditViewController;

@interface ImageEntryView : UIImageView <ImageEditViewControllerDelegate>

@property(nonatomic, weak)   id<ImageEntryViewDelegate>     delegate;
@property(nonatomic, strong) ImageEditViewController*       imageEditViewController;
@property(nonatomic, strong) Capture*                       capture;
@property(nonatomic, strong) UIView*                        commentView;
@property(nonatomic, strong) UILabel*                       commentLabel;
@property(nonatomic, strong) UITapGestureRecognizer*        editImageGesture;
@property(nonatomic, strong) UITapGestureRecognizer*        singleTapGesture;

+ (id)withFrame:(CGRect)_frame capture:(Capture*)_capture andDelegate:(id<ImageEntryViewDelegate>)_delegate;
- (id)initWithFrame:(CGRect)_frame capture:(Capture*)_capture andDelegate:(id<ImageEntryViewDelegate>)_delegate;
- (void)addCommentView;;

@end

@protocol ImageEntryViewDelegate <NSObject>

@optional

- (void)didSingleTapImage;
- (void)touchEnabled:(BOOL)_enabled;

@end
