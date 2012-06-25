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
#import "Image.h"
#import "NSArray+Extensions.h"

/////////////////////////////////////////////////////////////////////////////////////////
static CaptureManager* thisCaptureManager;

/////////////////////////////////////////////////////////////////////////////////////////
@interface CaptureManager (PrivateAPI)

NSInteger descendingSort(id num1, id num2, void *context);

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation CaptureManager

@synthesize fullSizeImageQueue;

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

- (void)waitForFullSizeImageQueue {
    dispatch_sync(self.fullSizeImageQueue, ^{});
}

- (void)dispatchAsyncFullSizeImageQueue:(void(^)(void))_job {
    dispatch_async(self.fullSizeImageQueue, _job);
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
    Image* fullSizePhoto = [self fetchFullSizeImageForCapture:_capture];
    if (fullSizePhoto) {
        [contextManager.mainObjectContext deleteObject:fullSizePhoto];
    }
    [contextManager.mainObjectContext deleteObject:_capture];
    [contextManager save];
    [[ViewGeneral instance] updateCalendarEntryWithDate:createdAt];
}

+ (Capture*)createCaptureWithImage:(UIImage*)_capturedImage scaledToFrame:(CGRect)_frame {
    NSDate* createdAt = [NSDate date];
    CLLocationCoordinate2D currentLocation = [[[LocationManager instance] location] coordinate];
    DataContextManager* contextManager = [DataContextManager instance];
    ViewGeneral* viewGeneral = [ViewGeneral instance];
    Capture* capture = (Capture*)[NSEntityDescription insertNewObjectForEntityForName:@"Capture" inManagedObjectContext:contextManager.mainObjectContext];

    capture.createdAt = createdAt;
    capture.dayIdentifier = [self dayIdentifier:capture.createdAt];
    capture.thumbnail = [_capturedImage thumbnailImage:[viewGeneral calendarImageThumbnailRect].size.width];
    capture.cached = [NSNumber numberWithBool:YES];
    
    Location* location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:contextManager.mainObjectContext];
    location.latitude  = [NSNumber numberWithDouble:currentLocation.latitude];
    location.longitude = [NSNumber numberWithDouble:currentLocation.longitude];
    capture.location = location;
    
    Image* displayedImage = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:contextManager.mainObjectContext];
	displayedImage.image = [self scaleImage:_capturedImage toFrame:_frame];
    displayedImage.imageId = [NSNumber numberWithInt:0];
	capture.displayedImage = displayedImage;

    NSInteger fullSizeImageId = 1000.0f*[NSDate timeIntervalSinceReferenceDate];
    capture.fullSizeImageId = [NSNumber numberWithInt:fullSizeImageId];
    [contextManager save];

    return [self fetchCaptureCreatedAt:createdAt];
}

+ (Capture*)fetchCaptureCreatedAt:(NSDate*)_createdAt {
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

- (void)createFullSizeImage:(UIImage*)_capturedImage forCapture:(Capture*)_capture {
    dispatch_async(self.fullSizeImageQueue, ^{
        NSError *error = nil;
        NSManagedObjectContext* requestMoc = [[DataContextManager instance] createContext];
        NSNotificationCenter *notify = [NSNotificationCenter defaultCenter];
        [notify addObserver:[DataContextManager instance] selector:@selector(mergeChangesWithMainContext:) name:NSManagedObjectContextDidSaveNotification object:requestMoc];        
        Image* fullSizeImage = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:requestMoc];
        fullSizeImage.image = _capturedImage;
        fullSizeImage.imageId = _capture.fullSizeImageId;
        if (![requestMoc save:&error]) {
            [ViewGeneral alertOnError:error];
        }
    });
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (Image*)fetchFullSizeImageForCapture:(Capture*)_capture {
    Image* fullSizeImage = nil;
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Image" inManagedObjectContext:contextManager.mainObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"imageId == %@", _capture.fullSizeImageId]];
    fetchRequest.fetchLimit = 1;
    NSArray* fetchResults = [contextManager fetch:fetchRequest];
    if ([fetchResults count] > 0) {
        fullSizeImage = [fetchResults objectAtIndex:0];
    }
    return fullSizeImage;
}

+ (void)applyFilterToFullSizeImage:(Filter*)_filter withValue:(NSNumber*)_value toCapture:(Capture*)_capture {
    Image* fullSizeImage = [self fetchFullSizeImageForCapture:_capture];
    UIImage* unfilteredFullSizeImage = fullSizeImage.image;
    fullSizeImage.image = [FilterFactory applyFilter:_filter withValue:_value toImage:unfilteredFullSizeImage];
    [[DataContextManager instance] save];
}

+ (NSUInteger)countFullSizeImages {
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Image" inManagedObjectContext:contextManager.mainObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"imageId != 0"]];
    return [contextManager count:fetchRequest];
}

+ (NSUInteger)countDisplayImages {
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Image" inManagedObjectContext:contextManager.mainObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"imageId == 0"]];
    return [contextManager count:fetchRequest];
}

@end
