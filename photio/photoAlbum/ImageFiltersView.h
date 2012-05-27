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
@class FilterUsage;
@class BouncingPanGestureRecognizer;

@interface ImageFiltersView : UIView <FilterImageViewDelegate>

@property(nonatomic, weak)      id<ImageFiltersViewDelegate>    filtersViewDelegate;
@property(nonatomic, assign)    FilterClassUsage*               filterClass;
@property(nonatomic, strong)    UIView*                         contentView;
@property(nonatomic, strong)    BouncingPanGestureRecognizer*   panGestureRecognizer;
@property(nonatomic, strong)    NSMutableDictionary*            filterViews;

- (void)addFilterViews;
- (FilterImageView*)filterImageViewForFilter:(FilterUsage*)_filter;

@end

@protocol ImageFiltersViewDelegate <NSObject>

- (void)selectedFilter:(FilterUsage*)_filter;

@end