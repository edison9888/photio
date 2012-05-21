//
//  ImageFiltersView.m
//  photio
//
//  Created by Troy Stribling on 5/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageFiltersView.h"
#import "UIView+Extensions.h"
#import "FilterImageView.h"

@interface ImageFiltersView (PrivateAPI)

- (void)addFilterViews;

@end

@implementation ImageFiltersView

@synthesize filtersViewDelegate, filterClass;

#pragma mark -
#pragma mark ImageFiltersView PrivayeAPI

#pragma mark -
#pragma mark ImageFiltersView

+ (id)withDelegate:(id<ImageFiltersViewDelegate>)_delegate andFilterClass:(FilterClass)_filterClass {
    ImageFiltersView* view = (ImageFiltersView*)[UIView loadView:[self class]];
    view.filtersViewDelegate = _delegate;
    view.filterClass = _filterClass;
    [view addFilterViews];
    return view;
}

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)didMoveToSuperview {
}


- (void)addFilterViews {
    NSArray* filters = [[FilterFactory instance] filters:self.filterClass];
    CGFloat totalWidth = 0.0;
    NSInteger filterType = 0;
    for (NSDictionary* filter in filters) {
        FilterImageView* filterImage = [FilterImageView withDelegate:self andFilter:filter];
        CGRect oldRect = filterImage.frame;
        filterImage.frame = CGRectMake(oldRect.origin.x, oldRect.origin.y + totalWidth, oldRect.size.width, oldRect.size.height);
        totalWidth += filterImage.frame.size.width;
        filterType++;
        filterImage.filterType = filterType;
        [self addSubview:filterImage];
    }
    self.contentSize = CGSizeMake(totalWidth, self.frame.size.height);
}

#pragma mark -
#pragma mark FilterImageViewDelegate

- (void)applyFilter:(FilterType)_filter {
    [self.filtersViewDelegate applyFilter:_filter];
}

@end
