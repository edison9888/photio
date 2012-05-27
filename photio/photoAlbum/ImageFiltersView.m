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
#import "FilterUsage.h"

@interface ImageFiltersView (PrivateAPI)

@end

@implementation ImageFiltersView

@synthesize filtersViewDelegate, filterClass, contentView, panGestureRecognizer;

#pragma mark -
#pragma mark ImageFiltersView PrivayeAPI

#pragma mark -
#pragma mark ImageFiltersView

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
        self.clipsToBounds = YES;
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.frame.size.height, self.frame.size.height)];
    }
    return self;
}

- (void)didMoveToSuperview {
}

- (void)addFilterViews {
    NSArray* filters = [[FilterFactory instance] filters:self.filterClass];
    CGFloat totalWidth = 0.0;
    for (FilterUsage* filter in filters) {
        FilterImageView* filterImage = [FilterImageView withDelegate:self andFilter:filter];
        CGRect oldRect = filterImage.frame;
        filterImage.frame = CGRectMake(oldRect.origin.x + totalWidth, oldRect.origin.y, oldRect.size.width, oldRect.size.height);
        totalWidth += filterImage.frame.size.width;
        filterImage.filter = filter;
        [self.contentView addSubview:filterImage];
    }
    self.contentView.frame = CGRectMake(0.0, 0.0, totalWidth, self.frame.size.height);
    [self addSubview:self.contentView];
    self.panGestureRecognizer = [BouncingPanGestureRecognizer inView:self.contentView relativeToView:self];
}

#pragma mark -
#pragma mark FilterImageViewDelegate

- (void)selectedFilter:(FilterUsage*)_filter {
    [self.filtersViewDelegate selectedFilter:_filter];
}

@end
