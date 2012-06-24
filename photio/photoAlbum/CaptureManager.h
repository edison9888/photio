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
@class Image;

@interface CaptureManager : NSObject 

+ (CaptureManager*)instance;
+ (UIImage*)scaleImage:(UIImage*)_image toFrame:(CGRect)_frame;
+ (NSString*)dayIdentifier:(NSDate*)_date;

+ (Capture*)createCaptureWithImage:(UIImage*)_capturedImage scaledToFrame:(CGRect)_frame;
+ (void)saveCapture:(Capture*)_capture;
+ (void)deleteCapture:(Capture*)_capture;
+ (Capture*)fetchCaptureCreatedAt:(NSDate*)_createdAt;
+ (NSArray*)fetchCapturesWithDayIdentifier:(NSString*)_dayIdentifier;
+ (NSArray*)fetchCaptureForEachDayBetweenDates:(NSDate*)_startdate and:(NSDate*)_endDate;
+ (Capture*)fetchCaptureWithDayIdentifierCreatedAt:(NSDate*)_createdAt;

+ (void)createFullSizeImage:(UIImage*)_capturedImage forCapture:(Capture*)_capture;
+ (Image*)fetchFullSizeImageForCapture:(Capture*)_capture;
+ (void)applyFilterToFullSizeImage:(Filter*)_filter withValue:(NSNumber*)_value toCapture:(Capture*)_capture;
+ (NSUInteger)countFullSizeImages;
+ (NSUInteger)countDisplayImages;

@end
