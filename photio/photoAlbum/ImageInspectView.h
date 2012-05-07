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

@interface ImageInspectView : UIImageView <ImageEditViewControllerDelegate>

@property(nonatomic, strong) UIImage*       capture;
@property(nonatomic, strong) NSNumber*      latitude;
@property(nonatomic, strong) NSNumber*      longitude;
@property(nonatomic, strong) NSDate*        createdAt;
@property(nonatomic, strong) NSString*      comment;
@property(nonatomic, strong) NSString*      rating;

+ (id)withFrame:(CGRect)_frame andCapture:(Capture*)_capture;
+ (id)cachedWithFrame:(CGRect)_frame capture:(UIImage*)_capture andLocation:(CLLocationCoordinate2D)_location;
- (id)initWithFrame:(CGRect)_frame capture:(UIImage*)_capture date:(NSDate*)_date comment:(NSString*)_comment rating:(NSString*)_rating andLocation:(CLLocationCoordinate2D)_location;

@end
