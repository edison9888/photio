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
#import "FilterImageView.h"
#import "FilterUsage.h"

@interface ImageFiltersView (PrivateAPI)

@end

@implementation ImageFiltersView

@synthesize filtersViewDelegate, filterClass, contentView, contentViewFrame, panGestureRecognizer;

#pragma mark -
#pragma mark ImageFiltersView PrivayeAPI

- (void)valueChanged:(UIPanGestureRecognizer*)_panGesture {
    CGPoint dragDelta = [_panGesture translationInView:self];
    CGFloat newXOffset = self.contentViewFrame.origin.x + dragDelta.x;
    CGFloat minOffset = self.frame.size.width - self.contentView.frame.size.width;
    if (newXOffset < minOffset) {
        newXOffset = minOffset;
    } else if (newXOffset > 0.0) {
        newXOffset = 0.0;
    }
    switch (_panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            self.contentView.frame = CGRectMake(newXOffset, self.contentViewFrame.origin.y, self.contentViewFrame.size.width, self.contentViewFrame.size.height);
            break;
        case UIGestureRecognizerStateEnded:
            self.contentViewFrame = self.contentView.frame;
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark ImageFiltersView

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
        self.clipsToBounds = YES;
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(valueChanged:)];
        [self addGestureRecognizer:self.panGestureRecognizer];
        self.contentViewFrame = CGRectMake(0.0, 0.0, self.frame.size.height, self.frame.size.height);
        self.contentView = [[UIView alloc] initWithFrame:self.contentViewFrame];
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
        self.panGestureRecognizer.delegate = self;
        totalWidth += filterImage.frame.size.width;
        filterImage.filter = filter;
        [self.contentView addSubview:filterImage];
    }
    self.contentViewFrame = CGRectMake(0.0, 0.0, totalWidth, self.frame.size.height);
    self.contentView.frame = self.contentViewFrame;
    [self addSubview:self.contentView];
}

#pragma mark -
#pragma mark FilterImageViewDelegate

- (void)selectedFilter:(FilterUsage*)_filter {
    [self.filtersViewDelegate selectedFilter:_filter];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)_gestureRecognizer shouldReceiveTouch:(UITouch*)_touch {
    NSLog(@"ImageFiltersView: %@", [_touch.view className]);
    return YES;
}

@end
