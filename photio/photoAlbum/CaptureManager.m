//
//  CaptureManager.m
//  photio
//
//  Created by Troy Stribling on 6/21/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CaptureManager.h"
#import "FilterFactory.h"
#import "ViewGeneral.h"
#import "Capture.h"
#import "UIImage+Resize.h"
#import "LocationManager.h"
#import "Location.h"
#import "Image.h"

#define SAVE_CAPTURE_DELAY      0.75f

/////////////////////////////////////////////////////////////////////////////////////////
static CaptureManager* thisCaptureManager;

/////////////////////////////////////////////////////////////////////////////////////////
@interface CaptureManager (PrivateAPI)

- (void)createFullSizeImageLater:(NSArray*)_args;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation CaptureManager

#pragma mark - 
#pragma mark CaptureManager PrivateAPI

- (void)createFullSizeImageLater:(NSArray*)_args {
    UIImage* capturedImage = [_args objectAtIndex:0];
    Capture* capture = [_args objectAtIndex:1];
    ViewGeneral* viewGeneral = [ViewGeneral instance];
    Image* fullSizeImage = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:viewGeneral.managedObjectContext];
	fullSizeImage.image = capturedImage;
    fullSizeImage.imageId = capture.fullSizeImageId;
    [viewGeneral saveManagedObjectContext];
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

+ (void)saveCapture:(Capture*)_capture {
    ViewGeneral* viewGeneral = [ViewGeneral instance];
    [viewGeneral saveManagedObjectContext];
    [viewGeneral updateCalendarEntryWithDate:_capture.createdAt];
}

+ (Capture*)createCaptureWithImage:(UIImage*)_capturedImage scaledToFrame:(CGRect)_frame {
    NSDate* createdAt = [NSDate date];
    CLLocationCoordinate2D currentLocation = [[[LocationManager instance] location] coordinate];
    ViewGeneral* viewGeneral = [ViewGeneral instance];
    Capture* capture = (Capture*)[NSEntityDescription insertNewObjectForEntityForName:@"Capture" inManagedObjectContext:viewGeneral.managedObjectContext];

    capture.createdAt = createdAt;
    capture.dayIdentifier = [viewGeneral dayIdentifier:capture.createdAt];
    capture.thumbnail = [_capturedImage thumbnailImage:[viewGeneral calendarImageThumbnailRect].size.width];
    capture.cached = [NSNumber numberWithBool:YES];
    
    Location* location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:viewGeneral.managedObjectContext];
    location.latitude  = [NSNumber numberWithDouble:currentLocation.latitude];
    location.longitude = [NSNumber numberWithDouble:currentLocation.longitude];
    capture.location = location;
    
    Image* displayedImage = [NSEntityDescription insertNewObjectForEntityForName:@"Image" inManagedObjectContext:viewGeneral.managedObjectContext];
	displayedImage.image = [self scaleImage:_capturedImage toFrame:_frame];
	capture.displayedImage = displayedImage;

    NSInteger fullSizeImageId = 1000.0f*[NSDate timeIntervalSinceReferenceDate];
    capture.fullSizeImageId = [NSNumber numberWithInt:fullSizeImageId];
    [viewGeneral saveManagedObjectContext];

    return [self fetchCaptureCreatedAt:createdAt];
}

+ (void)createFullSizeImage:(UIImage*)_capturedImage forCapture:(Capture*)_capture {
    NSArray* args = [NSArray arrayWithObjects:_capturedImage, _capture, nil];
    [[self instance] performSelector:@selector(createFullSizeImageLater:) withObject:args afterDelay:1.0];
}

+ (Capture*)fetchCaptureCreatedAt:(NSDate*)_createdAt {
    Capture* capture = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Capture" inManagedObjectContext:[[ViewGeneral instance] managedObjectContext]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"createdAt == %@", _createdAt]];
    fetchRequest.fetchLimit = 1;
    NSArray* fetchResults = [[ViewGeneral instance] fetchFromManagedObjectContext:fetchRequest];
    if ([fetchResults count] > 0) {
        capture = [fetchResults objectAtIndex:0];
    }
    return capture;
}

+ (Image*)fetchFullSizeImageForCapture:(Capture*)_capture {
    Image* fullSizeImage = nil;
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Image" inManagedObjectContext:[[ViewGeneral instance] managedObjectContext]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"imageId == %@", _capture.fullSizeImageId]];
    fetchRequest.fetchLimit = 1;
    NSArray* fetchResults = [[ViewGeneral instance] fetchFromManagedObjectContext:fetchRequest];
    if ([fetchResults count] > 0) {
        fullSizeImage = [fetchResults objectAtIndex:0];
    }
    return fullSizeImage;
}

+ (void)deleteCapture:(Capture*)_capture; {
    NSDate* createdAt = _capture.createdAt;
    ViewGeneral* viewGeneral = [ViewGeneral instance];
    [viewGeneral.managedObjectContext deleteObject:_capture];
    [viewGeneral saveManagedObjectContext];
    [viewGeneral updateCalendarEntryWithDate:createdAt];
}

+ (void)applyFilterToFullSizeImage:(Filter*)_filter withValue:(NSNumber*)_value toCapture:(Capture*)_capture {
    Image* fullSizeImage = [self fetchFullSizeImageForCapture:_capture];
    UIImage* unfilteredFullSizeImage = fullSizeImage.image;
    fullSizeImage.image = [FilterFactory applyFilter:_filter withValue:_value toImage:unfilteredFullSizeImage];
    [[ViewGeneral instance] saveManagedObjectContext];
}

@end
