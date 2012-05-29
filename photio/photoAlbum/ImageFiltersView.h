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

@class FilterPalette;
@class Filter;
@class BouncingPanGestureRecognizer;

@interface ImageFiltersView : UIView <FilterImageViewDelegate>

@property(nonatomic, weak)      id<ImageFiltersViewDelegate>    filtersViewDelegate;
@property(nonatomic, assign)    FilterPalette*                  filterPalette;
@property(nonatomic, strong)    UIView*                         contentView;
@property(nonatomic, strong)    BouncingPanGestureRecognizer*   panGestureRecognizer;
@property(nonatomic, strong)    NSMutableDictionary*            filterViews;

- (void)addFilterViews;
- (FilterImageView*)filterImageViewForFilter:(Filter*)_filter;

@end

@protocol ImageFiltersViewDelegate <NSObject>

- (void)selectedFilter:(Filter*)_filter;

@end