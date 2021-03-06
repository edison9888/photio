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
@property(nonatomic, assign) dispatch_queue_t fullSizeImageQueue;

+ (CaptureManager*)instance;
+ (UIImage*)scaleImage:(UIImage*)_image toFrame:(CGRect)_frame;
+ (NSString*)dayIdentifier:(NSDate*)_date;

+ (void)saveCapture:(Capture*)_capture;
+ (void)deleteCapture:(Capture*)_capture;

+ (Capture*)fetchCaptureWithId:(NSNumber*)_captureId;
+ (Capture*)fetchCaptureWithId:(NSNumber*)_captureId inContext:(NSManagedObjectContext*)_context;
+ (NSArray*)fetchCapturesWithDayIdentifier:(NSString*)_dayIdentifier;
+ (NSArray*)fetchCapturesWithDayIdentifier:(NSString*)_dayIdentifier betweenDates:(NSDate*)_startdate and:(NSDate*)_endDate;
+ (NSArray*)fetchCaptureForEachDayBetweenDates:(NSDate*)_startdate and:(NSDate*)_endDate;
+ (Capture*)fetchCaptureWithDayIdentifierCreatedAt:(NSDate*)_createdAt;

+ (UIImage*)fetchFullSizeImageForCapture:(Capture*)_capture;
+ (void)deleteFullSizeImageForCapture:(Capture*)_capture;
+ (void)applyFilterToFullSizeImage:(Filter*)_filter withValue:(NSNumber*)_value toCapture:(Capture*)_capture;

- (void)createCaptureInBackgroundForImage:(UIImage*)_capturedImage;
- (void)waitForCaptureImageQueue;
- (void)dispatchAsyncCaptureImageQueue:(void(^)(void))_job;
- (void)waitForFullSizeImageQueue;
- (void)dispatchAsyncFullSizeImageQueue:(void(^)(void))_job;
- (void)waitForQueues;

@end
