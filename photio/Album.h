//
//  Album.h
//  photio
//
//  Created by Troy Stribling on 7/6/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Album : NSManagedObject

@property (nonatomic, retain) NSNumber * captureCount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *capture;
@end

@interface Album (CoreDataGeneratedAccessors)

- (void)addCaptureObject:(NSManagedObject *)value;
- (void)removeCaptureObject:(NSManagedObject *)value;
- (void)addCapture:(NSSet *)values;
- (void)removeCapture:(NSSet *)values;

@end
