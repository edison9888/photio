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

@synthesize capture;

#pragma mark -
#pragma mark ImageInspectViewController PrivateAPI

#pragma mark -
#pragma mark ImageInspectViewController

+ (id)withFrame:(CGRect)_frame andCapture:(UIImage*)_capture {
    return [[ImageInspectView alloc] initWithFrame:_frame andCapture:_capture];
}

- (id)initWithFrame:(CGRect)_frame andCapture:(UIImage*)_capture {
    if ((self = [super initWithFrame:(CGRect)_frame])) {
        self.capture = _capture;
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
