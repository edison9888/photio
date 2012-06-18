//
//  ServiceUsed.h
//  photio
//
//  Created by Troy Stribling on 6/17/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Capture, Service;

@interface ServiceUsed : NSManagedObject

@property (nonatomic, retain) NSSet *service;
@property (nonatomic, retain) Capture *capture;
@end

@interface ServiceUsed (CoreDataGeneratedAccessors)

- (void)addServiceObject:(Service *)value;
- (void)removeServiceObject:(Service *)value;
- (void)addService:(NSSet *)values;
- (void)removeService:(NSSet *)values;

@end
