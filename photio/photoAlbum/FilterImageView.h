//
//  FilterImageView.h
//  photio
//
//  Created by Troy Stribling on 5/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterFactory.h"

@class FilterUsage;
@protocol FilterImageViewDelegate;

@interface FilterImageView : UIImageView <UIGestureRecognizerDelegate>

@property(nonatomic, weak)      id<FilterImageViewDelegate> delegate;
@property(nonatomic, strong)    FilterUsage*                filter;
@property(nonatomic, strong)    UITapGestureRecognizer*     selectGesture;

+ (id)withDelegate:(id<FilterImageViewDelegate>)_delegate andFilter:(FilterUsage*)_filter;

@end

@protocol FilterImageViewDelegate <NSObject>

- (void)selectedFilter:(FilterUsage*)_filter;

@end