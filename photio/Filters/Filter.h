//
//  Filter.h
//  photio
//
//  Created by Troy Stribling on 5/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Filter : NSObject

- (CGFloat)sliderMaxValue;
- (CGFloat)sliderMinValue;
- (CGFloat)sliderDefaultValue;
- (void)setFilterValue:(CGFloat)_value;
- (UIImage*)applyFilterToImage:(UIImage*)_filteredImage;

@end
