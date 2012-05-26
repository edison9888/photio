//
//  FilterFactory.h
//  photio
//
//  Created by Troy Stribling on 5/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

@class FilterClassUsage;
@class FilterUsage;

typedef enum {
    FilterTypeBrightness,
    FilterTypeContrast,
    FilterTypeColor,
    FilterTypeSaturation,
    FilterTypeVignette
} FilterType;

typedef enum {
    FilterClassFavotites,
    FilterClassImageAjustmentControls
} FilterClass;

@interface FilterFactory : NSObject

@property(nonatomic, strong) NSArray*   loadedFilerClasses;
@property(nonatomic, strong) NSArray*   loadedFilters;

+ (Filter*)filter:(FilterUsage*)_filter;
+ (FilterFactory*)instance;
- (FilterClassUsage*)defaultFilterClass;
- (FilterUsage*)defaultFilter:(FilterClassUsage*)_filterClass;
- (NSArray*)filterClasses;
- (NSArray*)filters:(FilterClassUsage*)_filterClass;

@end
