//
//  ImageFiltersView.h
//  photio
//
//  Created by Troy Stribling on 5/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterFactory.h"
#import "FilterImageView.h"

@protocol ImageFiltersViewDelegate;

@class FilterClassUsage;

@interface ImageFiltersView : UIScrollView <FilterImageViewDelegate>

@property(nonatomic, weak)      id<ImageFiltersViewDelegate>    filtersViewDelegate;
@property(nonatomic, assign)    FilterClass                     filterClass;

- (void)addFilterViews;

@end

@protocol ImageFiltersViewDelegate <NSObject>

- (void)applyFilter:(FilterType)_filter;

@end