//
//  FilterImageView.h
//  photio
//
//  Created by Troy Stribling on 5/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterFactory.h"

@protocol FilterImageViewDelegate;

@interface FilterImageView : UIImageView

@property(nonatomic, weak)      id<FilterImageViewDelegate> delegate;
@property(nonatomic, weak)      NSDictionary*               filter;
@property(nonatomic, assign)    FilterType                  filterType;

+ (id)withDelegate:(id<FilterImageViewDelegate>)_delegate andFilter:(NSDictionary*)_filter;

@end

@protocol FilterImageViewDelegate <NSObject>

- (void)applyFilter:(FilterType)_filter;

@end