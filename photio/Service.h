//
//  Service.h
//  photio
//
//  Created by Troy Stribling on 6/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ServiceUsed;

@interface Service : NSManagedObject

@property (nonatomic, retain) NSNumber * serviceId;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imageFilename;
@property (nonatomic, retain) NSNumber * usageCount;
@property (nonatomic, retain) NSNumber * usageRate;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSSet *serviceUsed;
@end

@interface Service (CoreDataGeneratedAccessors)

- (void)addServiceUsedObject:(ServiceUsed *)value;
- (void)removeServiceUsedObject:(ServiceUsed *)value;
- (void)addServiceUsed:(NSSet *)values;
- (void)removeServiceUsed:(NSSet *)values;

@end
