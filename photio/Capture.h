//
//  Capture.h
//  photio
//
//  Created by Troy Stribling on 7/7/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlbumCapture, CameraUsed, FilterUsed, ImageDisplay, ImageThumbnail, Locale, Location, ServiceUsed;

@interface Capture : NSManagedObject

@property (nonatomic, retain) NSNumber * cached;
@property (nonatomic, retain) NSNumber * captureId;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * dayIdentifier;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSSet *albums;
@property (nonatomic, retain) CameraUsed *cameraUsed;
@property (nonatomic, retain) ImageDisplay *displayImage;
@property (nonatomic, retain) NSSet *filterUsed;
@property (nonatomic, retain) Locale *locale;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *serviceUsed;
@property (nonatomic, retain) ImageThumbnail *thumbnail;
@end

@interface Capture (CoreDataGeneratedAccessors)

- (void)addAlbumsObject:(AlbumCapture *)value;
- (void)removeAlbumsObject:(AlbumCapture *)value;
- (void)addAlbums:(NSSet *)values;
- (void)removeAlbums:(NSSet *)values;

- (void)addFilterUsedObject:(FilterUsed *)value;
- (void)removeFilterUsedObject:(FilterUsed *)value;
- (void)addFilterUsed:(NSSet *)values;
- (void)removeFilterUsed:(NSSet *)values;

- (void)addServiceUsedObject:(ServiceUsed *)value;
- (void)removeServiceUsedObject:(ServiceUsed *)value;
- (void)addServiceUsed:(NSSet *)values;
- (void)removeServiceUsed:(NSSet *)values;

@end
