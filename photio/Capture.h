//
//  Capture.h
//  photio
//
//  Created by Troy Stribling on 6/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album, CameraUsed, Image;

@interface Capture : NSManagedObject

@property (nonatomic, retain) NSNumber * cached;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * dayIdentifier;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * rating;
@property (nonatomic, retain) id thumbnail;
@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) CameraUsed *locale;
@property (nonatomic, retain) NSSet *album;
@property (nonatomic, retain) CameraUsed *cameraUsed;
@property (nonatomic, retain) NSSet *filterUsed;
@end

@interface Capture (CoreDataGeneratedAccessors)

- (void)addAlbumObject:(Album *)value;
- (void)removeAlbumObject:(Album *)value;
- (void)addAlbum:(NSSet *)values;
- (void)removeAlbum:(NSSet *)values;

- (void)addFilterUsedObject:(NSManagedObject *)value;
- (void)removeFilterUsedObject:(NSManagedObject *)value;
- (void)addFilterUsed:(NSSet *)values;
- (void)removeFilterUsed:(NSSet *)values;

@end
