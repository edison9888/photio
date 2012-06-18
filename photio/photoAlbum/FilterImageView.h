//
//  FilterImageView.h
//  photio
//
//  Created by Troy Stribling on 5/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterFactory.h"

@class Filter;
@class FilterSelectedView;

@protocol FilterImageViewDelegate;

@interface FilterImageView : UIImageView <UIGestureRecognizerDelegate>

@property(nonatomic, weak)      id<FilterImageViewDelegate> delegate;
@property(nonatomic, strong)    Filter*                     filter;
@property(nonatomic, strong)    UITapGestureRecognizer*     selectGesture;
@property(nonatomic, strong)    FilterSelectedView*         selectedView;
@property(nonatomic, assign)    BOOL                        selected;

+ (id)withDelegate:(id<FilterImageViewDelegate>)_delegate andFilter:(Filter*)_filter;
- (void)select;
- (void)deselect;

@end

@protocol FilterImageViewDelegate <NSObject>

- (void)selectedFilter:(FilterImageView*)_filter;

@end