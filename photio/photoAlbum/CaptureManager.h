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

@property(nonatomic, assign) dispatch_queue_t captureImageQueue;

+ (CaptureManager*)instance;
+ (UIImage*)scaleImage:(UIImage*)_image toFrame:(CGRect)_frame;
+ (NSString*)dayIdentifier:(NSDate*)_date;

+ (void)saveCapture:(Capture*)_capture;
+ (void)deleteCapture:(Capture*)_capture;

+ (Capture*)fetchCaptureCreatedAt:(NSDate*)_createdAt;
+ (Capture*)fetchCaptureCreatedAt:(NSDate*)_createdAt inContext:(NSManagedObjectContext*)_context;
+ (NSArray*)fetchCapturesWithDayIdentifier:(NSString*)_dayIdentifier;
+ (NSArray*)fetchCaptureForEachDayBetweenDates:(NSDate*)_startdate and:(NSDate*)_endDate;
+ (Capture*)fetchCaptureWithDayIdentifierCreatedAt:(NSDate*)_createdAt;

+ (UIImage*)fetchFullSizeImageForCapture:(Capture*)_capture;
+ (void)applyFilterToFullSizeImage:(Filter*)_filter withValue:(NSNumber*)_value toCapture:(Capture*)_capture;

+ (NSUInteger)countFullSizeImages;
+ (NSUInteger)countDisplayImages;

- (void)createCaptureInBackgroundForImage:(UIImage*)_capturedImage;
- (void)waitForCaptureImageQueue;
- (void)dispatchAsyncCaptureImageQueue:(void(^)(void))_job;


@end
