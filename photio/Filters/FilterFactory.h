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
    FilterClassImageAjustmentControls
} FilterClass;

@interface FilterFactory : NSObject

@property(nonatomic, strong) NSDictionary*  filtersByClass;

+ (Filter*)filter:(FilterType)_filterName;
- (NSArray*)filterClassViews;
- (NSArray*)filterViews:(FilterClass)_filterClass;

@end
