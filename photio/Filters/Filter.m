//
//  Filter.m
//  photio
//
//  Created by Troy Stribling on 5/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "Filter.h"

@implementation Filter

- (CGFloat)sliderMaxValue {
    return 1.0;
}

- (CGFloat)sliderMinValue {
    return 0.0;
}

- (CGFloat)sliderDefaultValue {
    return 0.0;
}

- (void)setFilterValue:(CGFloat)_value {
}

- (UIImage*)applyFilterToImage:(UIImage*)_filteredImage {
    return nil;
}

@end