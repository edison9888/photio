//
//  ImageInspectView.m
//  photio
//
//  Created by Troy Stribling on 4/5/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageInspectView.h"
#import "UIImage+Resize.h"
#import "Capture.h"
#import "Image.h"
#import "ViewGeneral.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageInspectView (PrivateAPI)

- (void)editImage;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageInspectView

@synthesize capture, latitude, longitude, createdAt;

#pragma mark -
#pragma mark ImageInspectView PrivateAPI

- (void)editImage {
    [[ViewGeneral instance] initImageEditView:self];
}

#pragma mark -
#pragma mark ImageInspectView

+ (id)withFrame:(CGRect)_frame andCapture:(Capture*)_capture {
    return [[ImageInspectView alloc] initWithFrame:_frame capture:_capture.image.image date:_capture.createdAt 
               andLocation:CLLocationCoordinate2DMake([_capture.latitude doubleValue], [_capture.longitude doubleValue])];
}

+ (id)cachedWithFrame:(CGRect)_frame capture:(UIImage*)_capture andLocation:(CLLocationCoordinate2D)_location {
    ImageInspectView* view = [[ImageInspectView alloc] initWithFrame:_frame capture:_capture date:[NSDate date] andLocation:_location];
    view.capture = _capture;
    return view;
}

- (id)initWithFrame:(CGRect)_frame capture:(UIImage*)_capture date:(NSDate*)_date andLocation:(CLLocationCoordinate2D)_location {
    if ((self = [super initWithFrame:(CGRect)_frame])) {
        self.latitude = [NSNumber numberWithDouble:_location.latitude];
        self.longitude = [NSNumber numberWithDouble:_location.longitude];
        self.createdAt = _date;
        self.image = [_capture scaleToSize:_frame.size];
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer* editImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editImage)];
        editImageGesture.numberOfTapsRequired = 2;
        editImageGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:editImageGesture];
    }
    return self;
}

@end
