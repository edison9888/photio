//
//  FilterFactory.h
//  photio
//
//  Created by Troy Stribling on 5/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

typedef enum {
    FilterTypeSaturation
} FilterType;

typedef enum {
    FilterClassFavotites,
    FilterClassImageAjustmentControls
} FilterClass;

@interface FilterFactory : NSObject

@property(nonatomic, strong) NSArray*   filerClasses;
@property(nonatomic, strong) NSArray*   filters;

+ (Filter*)filter:(FilterType)_filterName;
+ (FilterFactory*)instance;
- (NSDictionary*)defaultFilterClass;
- (NSArray*)filterClasses;
- (NSArray*)filters:(FilterClass)_filterClass;

@end
