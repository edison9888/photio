//
//  ImageInspectView.h
//  photio
//
//  Created by Troy Stribling on 4/5/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface ImageInspectView : UIImageView

@property(nonatomic, strong) UIImage*   capture;
@property(nonatomic, strong) NSNumber*  latitude;
@property(nonatomic, strong) NSNumber*  longitude;
@property(nonatomic, strong) NSDate*    createdAt;

+ (id)withFrame:(CGRect)_frame capture:(UIImage*)_capture andLocation:(CLLocationCoordinate2D)_location;
- (id)initWithFrame:(CGRect)_frame capture:(UIImage*)_capture andLocation:(CLLocationCoordinate2D)_location;

@end
