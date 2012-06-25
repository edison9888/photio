//
//  Capture.h
//  photio
//
//  Created by Troy Stribling on 6/24/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album, CameraUsed, FilterUsed, Image, Locale, Location, ServiceUsed;

@interface Capture : NSManagedObject

@property (nonatomic, retain) NSNumber * cached;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * dayIdentifier;
@property (nonatomic, retain) NSNumber * fullSizeImageId;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) id thumbnail;
@property (nonatomic, retain) NSSet *album;
@property (nonatomic, retain) CameraUsed *cameraUsed;
@property (nonatomic, retain) Image *displayedImage;
@property (nonatomic, retain) NSSet *filterUsed;
@property (nonatomic, retain) Locale *locale;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) NSSet *serviceUsed;
@end

@interface Capture (CoreDataGeneratedAccessors)

- (void)addAlbumObject:(Album *)value;
- (void)removeAlbumObject:(Album *)value;
- (void)addAlbum:(NSSet *)values;
- (void)removeAlbum:(NSSet *)values;

- (void)addFilterUsedObject:(FilterUsed *)value;
- (void)removeFilterUsedObject:(FilterUsed *)value;
- (void)addFilterUsed:(NSSet *)values;
- (void)removeFilterUsed:(NSSet *)values;

- (void)addServiceUsedObject:(ServiceUsed *)value;
- (void)removeServiceUsedObject:(ServiceUsed *)value;
- (void)addServiceUsed:(NSSet *)values;
- (void)removeServiceUsed:(NSSet *)values;

@end
