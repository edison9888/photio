//
//  ImageInspectView.m
//  photio
//
//  Created by Troy Stribling on 4/5/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageInspectView.h"
#import "UIImage+Resize.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageInspectView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageInspectView

@synthesize capture, latitude, longitude, createdAt;

#pragma mark -
#pragma mark ImageInspectViewController PrivateAPI

#pragma mark -
#pragma mark ImageInspectViewController

+ (id)withFrame:(CGRect)_frame capture:(UIImage*)_capture andLocation:(CLLocationCoordinate2D)_location {
    return [[ImageInspectView alloc] initWithFrame:_frame capture:_capture andLocation:_location];
}

- (id)initWithFrame:(CGRect)_frame capture:(UIImage*)_capture andLocation:(CLLocationCoordinate2D)_location {
    if ((self = [super initWithFrame:(CGRect)_frame])) {
        self.capture = _capture;
        self.latitude = [NSNumber numberWithDouble:_location.latitude];
        self.longitude = [NSNumber numberWithDouble:_location.longitude];
        self.createdAt = [NSDate date];
        BOOL retina = NO;
        CGRect imageFrame = _frame;
        CGFloat imageScale = 1.0;
        if([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
            if ([[UIScreen mainScreen] scale] == 2.0) {
                retina = YES;
                imageFrame = CGRectMake(2.0*_frame.origin.x, 2.0*_frame.origin.y, 2.0*_frame.size.width, 2.0*_frame.size.height);
                imageScale = 2.0;
            }
        }
        UIImage* scaledImage = [self.capture scaleToFrame:imageFrame];
        self.image = [UIImage imageWithCGImage:[scaledImage CGImage] scale:imageScale orientation:scaledImage.imageOrientation];
        self.contentMode = UIViewContentModeScaleAspectFill;
    }
    return self;
}

@end
