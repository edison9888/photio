//
//  ImageEditView.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterSliderView.h"
#import "FilterFactory.h"
#import "ImageFiltersView.h"

@class ImageControlView;
@class ParameterSliderView;
@class FilterClassUsage;
@class FilterUsage;
@class Filter;

@protocol ImageEditViewDelegate;

@interface ImageEditView : UIView <ParameterSliderViewDelegate, ImageFiltersViewDelegate>

@property(nonatomic, weak)   id<ImageEditViewDelegate>          delegate;
@property(nonatomic, strong) UIView*                            containerView;
@property(nonatomic, strong) IBOutlet UIView*                   controlContainerView;
@property(nonatomic, strong) IBOutlet UIView*                   filterContainerView;
@property(nonatomic, strong) IBOutlet ParameterSliderView*      parameterSlider;
@property(nonatomic, strong) IBOutlet UIImageView*              imageSaveFilteredImageView;
@property(nonatomic, strong) IBOutlet UIImageView*              imageFilterClassView;
@property(nonatomic, strong) IBOutlet ImageFiltersView*         imageFiltersView;
@property(nonatomic, strong) Filter*                            filterToApply;
@property(nonatomic, assign) FilterUsage*                       displayedFilter;
@property(nonatomic, assign) FilterClassUsage*                  displayedFilterClass;
@property(nonatomic, assign) BOOL                               isInitialized;

+ (id)withDelegate:(id<ImageEditViewDelegate>)_delegate;

@end

@protocol ImageEditViewDelegate <NSObject>

@required

- (void)applyFilter:(Filter*)_filter;
- (void)saveFilteredImage:(Filter*)_filter;
- (void)resetFilteredImage;

@end
