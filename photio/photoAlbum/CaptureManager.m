//
//  CaptureManager.m
//  photio
//
//  Created by Troy Stribling on 6/21/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CaptureManager.h"
#import "PhotioAppDelegate.h"
#import "FilterFactory.h"
#import "ViewGeneral.h"
#import "DataContextManager.h"
#import "Capture.h"
#import "UIImage+Resize.h"
#import "LocationManager.h"
#import "Location.h"
#import "ImageThumbnail.h"
#import "ImageDisplay.h"
#import "NSArray+Extensions.h"

/////////////////////////////////////////////////////////////////////////////////////////
static CaptureManager* thisCaptureManager;

/////////////////////////////////////////////////////////////////////////////////////////
@interface CaptureManager (PrivateAPI)

NSInteger descendingSort(id num1, id num2, void *context);
- (Capture*)createCaptureWithImage:(UIImage*)_capturedImage inContext:(NSManagedObjectContext*)_context;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation CaptureManager

@synthesize captureImageQueue, fullSizeImageQueue;

#pragma mark - 
#pragma mark CaptureManager PrivateAPI

NSInteger descendingSort(id num1, id num2, void* context) {
    int v1 = [num1 intValue];
    int v2 = [num2 intValue];
    if (v1 > v2) {
        return NSOrderedAscending;
    } else if (v1 < v2) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (Capture*)createCaptureWithImage:(UIImage*)_capturedImage inContext:(NSManagedObjectContext*)_context {
    NSDate* createdAt = [NSDate date];
    CLLocationCoordinate2D currentLocation = [[[LocationManager instance] location] coordinate];
    DataContextManager* contextManager = [DataContextManager instance];
    Capture* capture = (Capture*)[NSEntityDescription insertNewObjectForEntityForName:@"Capture" inManagedObjectContext:contextManager.mainObjectContext];

    capture.createdAt = createdAt;
    capture.dayIdentifier = [self.class dayIdentifier:capture.createdAt];
    capture.cached = [NSNumber numberWithBool:YES];

    ImageThumbnail* thumbnail = [NSEntityDescription insertNewObjectForEntityForName:@"ImageThumbnail" inManagedObjectContext:contextManager.mainObjectContext];
    thumbnail.image = [_capturedImage thumbnailImage:[[ViewGeneral instance] calendarImageThumbnailRect].size.width];;
    capture.thumbnail = thumbnail;

    ImageDisplay* displayImage = [NSEntityDescription insertNewObjectForEntityForName:@"ImageDisplay" inManagedObjectContext:contextManager.mainObjectContext];
    displayImage.image = [self.class scaleImage:_capturedImage toFrame:[ViewGeneral instance].containerView.frame];
    capture.displayImage = displayImage;

    Location* location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:contextManager.mainObjectContext];
    location.latitude  = [NSNumber numberWithDouble:currentLocation.latitude];
    location.longitude = [NSNumber numberWithDouble:currentLocation.longitude];
    capture.location = location;

    [contextManager save];
    return capture;
}

#pragma mark - 
#pragma mark CaptureManager

+ (CaptureManager*)instance {
    @synchronized(self) {
        if (thisCaptureManager == nil) {
            thisCaptureManager = [[self alloc] init];
        }
    }
    return thisCaptureManager;
}

- (id)init {
    self = [super init];
    if (self) {
        self.captureImageQueue = dispatch_queue_create("com.photio.captureImage", NULL);
        self.fullSizeImageQueue = dispatch_queue_create("com.photio.fullSizeImage", NULL);
    }
    return self;
}

+ (UIImage*)scaleImage:(UIImage*)_image toFrame:(CGRect)_frame {
    CGFloat imageAspectRatio = _image.size.height / _image.size.width;
    CGFloat scaledImageWidth = _frame.size.width;
    CGFloat scaledImageHeight = MAX(scaledImageWidth * imageAspectRatio, _frame.size.height);
    if (imageAspectRatio < 1.0) {
        scaledImageHeight = imageAspectRatio * scaledImageWidth;
    }
    CGSize scaledImageSize = CGSizeMake(scaledImageWidth, scaledImageHeight);
    return [_image scaleToSize:scaledImageSize];
}

+ (NSString*)dayIdentifier:(NSDate*)_date {
    NSDateFormatter* julianDayFormatter = [[NSDateFormatter alloc] init];
    [julianDayFormatter setDateFormat:@"g"];
    return [julianDayFormatter stringFromDate:_date];
}

#pragma mark - 
#pragma mark CaptureManager Queues

- (void)waitForCaptureImageQueue {
    dispatch_sync(self.captureImageQueue, ^{});
}

- (void)dispatchAsyncCaptureImageQueue:(void(^)(void))_job {
    dispatch_async(self.captureImageQueue, _job);
}

- (void)waitForFullSizeImageQueue {
    dispatch_sync(self.fullSizeImageQueue, ^{});    
}

- (void)dispatchAsyncFullSizeImageQueue:(void(^)(void))_job {
    dispatch_async(self.fullSizeImageQueue, _job);
}

- (void)waitForQueues {
    [self waitForCaptureImageQueue];
    [self waitForFullSizeImageQueue];
}

#pragma mark - 
#pragma mark Captures

+ (void)saveCapture:(Capture*)_capture {
    [[DataContextManager instance] save];
    [[ViewGeneral instance] updateCalendarEntryWithDate:_capture.createdAt];
}

+ (void)deleteCapture:(Capture*)_capture; {
    DataContextManager* contextManager = [DataContextManager instance];
    NSDate* createdAt = _capture.createdAt;
    [contextManager.mainObjectContext deleteObject:_capture];
    [contextManager save];
    [[ViewGeneral instance] updateCalendarEntryWithDate:createdAt];
}

- (void)createCaptureInBackgroundForImage:(UIImage*)_capturedImage {
    dispatch_async(self.captureImageQueue, ^{
        NSManagedObjectContext* requestMoc = [[DataContextManager instance] createContext];
        NSNotificationCenter *notify = [NSNotificationCenter defaultCenter];
        [notify addObserver:[DataContextManager instance] selector:@selector(mergeChangesWithMainContext:) name:NSManagedObjectContextDidSaveNotification object:requestMoc];        
        
        Capture* capture = [self createCaptureWithImage:_capturedImage inContext:requestMoc];
        NSDate* createdAt = capture.createdAt;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[ViewGeneral instance] addCapture:[self.class fetchCaptureCreatedAt:createdAt]];
        });

        dispatch_async(self.fullSizeImageQueue, ^{
            NSString* imageFilename = [NSString stringWithFormat:@"Documents/%@.jpg", capture.createdAt];
            NSString* jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:imageFilename]; 
            [UIImageJPEGRepresentation(_capturedImage, 1.0f) writeToFile:jpgPath atomically:YES];
        });
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (Capture*)fetchCaptureCreatedAt:(NSDate*)_createdAt {
    return [self fetchCaptureCreatedAt:_createdAt inContext:[DataContextManager instance].mainObjectContext];
}

+ (Capture*)fetchCaptureCreatedAt:(NSDate*)_createdAt inContext:(NSManagedObjectContext*)_context {
    Capture* capture = nil;
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Capture" inManagedObjectContext:contextManager.mainObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"createdAt == %@", _createdAt]];
    fetchRequest.fetchLimit = 1;
    NSArray* fetchResults = [contextManager fetch:fetchRequest];
    if ([fetchResults count] > 0) {
        capture = [fetchResults objectAtIndex:0];
    }
    return capture;
}

+ (NSArray*)fetchCapturesWithDayIdentifier:(NSString*)_dayIdentifier {
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Capture" inManagedObjectContext:contextManager.mainObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"dayIdentifier == %@", _dayIdentifier]];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO]]];
    return [contextManager fetch:fetchRequest];
}

+ (NSArray*)fetchCaptureForEachDayBetweenDates:(NSDate*)_startdate and:(NSDate*)_endDate {
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];    
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Capture" inManagedObjectContext:contextManager.mainObjectContext]];    
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"createdAt BETWEEN {%@, %@}", _startdate, _endDate]];    
    NSArray* fetchResults = [contextManager fetch:fetchRequest];
    
    NSArray* days = [fetchResults valueForKeyPath:@"@distinctUnionOfObjects.dayIdentifier"];
    NSArray* sortedDays = [days sortedArrayUsingFunction:descendingSort context:NULL];
    NSArray* aggregatedResults = [sortedDays mapObjectsUsingBlock:^id(id _obj, NSUInteger _idx) {
        NSString* day = _obj;
        NSArray* dayValues = [fetchResults filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"dayIdentifier == %@", day]];
        NSDate* latestDate = [dayValues valueForKeyPath:@"@max.createdAt"];
        return [[dayValues filteredArrayUsingPredicate:[NSPredicate predicateWithFormat: @"createdAt = %@", latestDate]] objectAtIndex:0];
    }];
    
    return aggregatedResults;
}

+ (Capture*)fetchCaptureWithDayIdentifierCreatedAt:(NSDate*)_createdAt {
    Capture* capture = nil;
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Capture" inManagedObjectContext:contextManager.mainObjectContext]];   
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"dayIdentifier==%@", [self dayIdentifier:_createdAt]]];
    [fetchRequest setFetchLimit:1];    
    NSArray* fetchResults = [contextManager fetch:fetchRequest];
    if ([fetchResults count] > 0) {
        capture = [fetchResults objectAtIndex:0];
    }
    return capture;
}

#pragma mark - 
#pragma mark Full Size Images

+ (UIImage*)fetchFullSizeImageForCapture:(Capture*)_capture {
    NSString* imageFilename = [NSString stringWithFormat:@"Documents/%@.jpg", _capture.createdAt];
    NSString* jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:imageFilename]; 
    return [UIImage imageWithContentsOfFile:jpgPath];
}

+ (void)applyFilterToFullSizeImage:(Filter*)_filter withValue:(NSNumber*)_value toCapture:(Capture*)_capture {
}

+ (NSUInteger)countFullSizeImages {
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ImageJPEG" inManagedObjectContext:contextManager.mainObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"imageId != 0"]];
    return [contextManager count:fetchRequest];
}

+ (NSUInteger)countDisplayImages {
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"ImageDisplay" inManagedObjectContext:contextManager.mainObjectContext]];
    return [contextManager count:fetchRequest];
}

@end
