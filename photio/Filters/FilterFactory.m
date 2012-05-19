//
//  FilterFactory.m
//  photio
//
//  Created by Troy Stribling on 5/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "FilterFactory.h"
#import "BuiltInFilter.h"

@implementation FilterFactory

+ (Filter*)filter:(FilterType)_filterType {
    Filter* filter = nil;
    switch (_filterType) {
        case FilterTypeVibrance:
            filter = [BuiltInFilter filter:@"CIVibrance" andAttribute:@"inputAmount"];
            break;
        default:
            break;
    }
    return filter;
}

@end
