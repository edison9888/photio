//
//  ImageEditView.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterSliderView.h"

@class ImageControlView;
@class ParameterSliderView;

@protocol ImageEditViewDelegate;

@interface ImageEditView : UIView <ParameterSliderViewDelegate>

@property(nonatomic, weak)   id<ImageEditViewDelegate>          delegate;
@property(nonatomic, strong) UIView*                            containerView;
@property(nonatomic, strong) IBOutlet UIView*                   controlContainerView;
@property(nonatomic, strong) IBOutlet UIView*                   filterContainerView;
@property(nonatomic, strong) IBOutlet ParameterSliderView*      parameterSlider;
@property(nonatomic, strong) IBOutlet ImageControlView*         imageControlsView;
@property(nonatomic, strong) IBOutlet ImageControlView*         imageFiltersView;
@property(nonatomic, strong) NSMutableDictionary*               filtersToApply;
@property(nonatomic, strong) NSMutableDictionary*               filtersLoaded;
@property(nonatomic, strong) NSString*                          displayedFilter;
@property(nonatomic, strong) NSString*                          displayedFilterClass;
@property(nonatomic, assign) BOOL                               displayedFilterLoaded;

+ (id)inView:(UIView*)_containerView withDelegate:(id<ImageEditViewDelegate>)_delegate;

@end

@protocol ImageEditViewDelegate <NSObject>

@required

- (void)applyFilters:(NSDictionary*)_filters;

@end
