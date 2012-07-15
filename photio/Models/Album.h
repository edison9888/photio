//
//  Album.h
//  photio
//
//  Created by Troy Stribling on 7/7/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlbumCapture;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSNumber * captureCount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *captures;
@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addCapturesObject:(AlbumCapture *)value;
- (void)removeCapturesObject:(AlbumCapture *)value;
- (void)addCaptures:(NSSet *)values;
- (void)removeCaptures:(NSSet *)values;

@end
