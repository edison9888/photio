//
//  CaptureManager.h
//  photio
//
//  Created by Troy Stribling on 6/21/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Capture;
@class Filter;

@interface CaptureManager : NSObject 

+ (CaptureManager*)instance;
+ (UIImage*)scaleImage:(UIImage*)_image toFrame:(CGRect)_frame;
+ (Capture*)createCaptureWithImage:(UIImage*)_capturedImage scaledToFrame:(CGRect)_frame;
+ (void)saveCapture:(Capture*)_capture;
+ (void)deleteCapture:(Capture*)_capture;
+ (Capture*)fetchCaptureCreatedAt:(NSDate*)_createdAt;
+ (Capture*)applyFilteredImage:(Filter*)_filter withValue:(NSNumber*)_value toCapture:(Capture*)_capture;

@end
