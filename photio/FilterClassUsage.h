//
//  FilterClassUsage.h
//  photio
//
//  Created by Troy Stribling on 5/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FilterUsage;

@interface FilterClassUsage : NSManagedObject

@property (nonatomic, retain) NSNumber * filterClassId;
@property (nonatomic, retain) NSString * imageFilename;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * usageCount;
@property (nonatomic, retain) NSNumber * usageSpeed;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSSet *filters;
@end

@interface FilterClassUsage (CoreDataGeneratedAccessors)

- (void)addFiltersObject:(FilterUsage *)value;
- (void)removeFiltersObject:(FilterUsage *)value;
- (void)addFilters:(NSSet *)values;
- (void)removeFilters:(NSSet *)values;

@end
