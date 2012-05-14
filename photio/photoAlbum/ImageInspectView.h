//
//  ImageInspectView.h
//  photio
//
//  Created by Troy Stribling on 4/5/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ImageEditViewController.h"

@class Capture;
@protocol ImageInspectViewDelegate;

@interface ImageInspectView : UIImageView <ImageEditViewControllerDelegate>

@property(nonatomic, weak)   id<ImageInspectViewDelegate>   delegate;
@property(nonatomic, strong) UIImage*                       capture;
@property(nonatomic, strong) UIView*                        commentView;
@property(nonatomic, strong) UILabel*                       commentLabel;
@property(nonatomic, strong) NSNumber*                      latitude;
@property(nonatomic, strong) NSNumber*                      longitude;
@property(nonatomic, strong) NSDate*                        createdAt;
@property(nonatomic, strong) NSString*                      comment;
@property(nonatomic, strong) NSString*                      rating;

+ (id)withFrame:(CGRect)_frame andCapture:(Capture*)_capture;
+ (id)withFrame:(CGRect)_frame capture:(UIImage*)_capture andLocation:(CLLocationCoordinate2D)_location;
- (id)initWithFrame:(CGRect)_frame capture:(UIImage*)_capture date:(NSDate*)_date andLocation:(CLLocationCoordinate2D)_location;
- (void)addCommentView;;

@end

@protocol ImageInspectViewDelegate <NSObject>

@optional

- (void)didSingleTapImage;
- (void)didFinishEditing:(ImageInspectView*)_imageView;

@end
