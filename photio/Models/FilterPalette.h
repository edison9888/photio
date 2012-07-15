//
//  FilterPalette.h
//  photio
//
//  Created by Troy Stribling on 6/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Filter;

@interface FilterPalette : NSManagedObject

@property (nonatomic, retain) NSNumber * filterPaletteId;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSString * imageFilename;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * usageCount;
@property (nonatomic, retain) NSNumber * usageRate;
@property (nonatomic, retain) NSSet *filters;
@end

@interface FilterPalette (CoreDataGeneratedAccessors)

- (void)addFiltersObject:(Filter *)value;
- (void)removeFiltersObject:(Filter *)value;
- (void)addFilters:(NSSet *)values;
- (void)removeFilters:(NSSet *)values;

@end
