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
    FilterTypeVibrance
} FilterType;

@interface FilterFactory : NSObject

+ (Filter*)filter:(FilterType)_filterName;

@end
