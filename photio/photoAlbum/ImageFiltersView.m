//
//  ImageFiltersView.m
//  photio
//
//  Created by Troy Stribling on 5/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageFiltersView.h"
#import "UIView+Extensions.h"
#import "NSObject+Extensions.h"
#import "BouncingPanGestureRecognizer.h"
#import "FilterImageView.h"
#import "FilterFactory.h"
#import "Filter.h"

@interface ImageFiltersView (PrivateAPI)

@end

@implementation ImageFiltersView

@synthesize filtersViewDelegate, contentView, panGestureRecognizer, filterViews;

#pragma mark -
#pragma mark ImageFiltersView PrivayeAPI

#pragma mark -
#pragma mark ImageFiltersView

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
        self.clipsToBounds = YES;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.height, self.frame.size.height)];
        self.filterViews = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

- (void)didMoveToSuperview {
}

- (void)removeFilterViews {
    for (UIView* filterView in self.contentView.subviews) {
        [filterView removeFromSuperview];
    }
}

- (void)addFilterViewsForFilterPalette:(FilterPalette*)_filterPalette {
    NSArray* filters = [[FilterFactory instance] filtersForPalette:_filterPalette];
    CGFloat totalWidth = 0.0;
    for (Filter* filter in filters) {
        FilterImageView* filterImage = [FilterImageView withDelegate:self andFilter:filter];
        CGRect oldRect = filterImage.frame;
        filterImage.frame = CGRectMake(oldRect.origin.x + totalWidth, oldRect.origin.y, oldRect.size.width, oldRect.size.height);
        totalWidth += filterImage.frame.size.width;
        filterImage.filter = filter;
        [self.filterViews setObject:filterImage forKey:filter.filterId];
        [self.contentView addSubview:filterImage];
    }
    self.contentView.frame = CGRectMake(0.0, 0.0, totalWidth, self.frame.size.height);
    [self addSubview:self.contentView];
    self.panGestureRecognizer = [BouncingPanGestureRecognizer inView:self.contentView relativeToView:self];
}

- (FilterImageView*)filterImageViewForFilter:(Filter*)_filter {
    return [self.filterViews objectForKey:_filter.filterId];
}

#pragma mark -
#pragma mark FilterImageViewDelegate

- (void)selectedFilter:(Filter*)_filter {
    [self.filtersViewDelegate selectedFilter:_filter];
}

@end
