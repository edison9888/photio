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
@property(nonatomic, strong) NSMutableDictionary*               filtersToApply;
@property(nonatomic, assign) FilterType                         displayedFilter;
@property(nonatomic, assign) FilterClass                        displayedFilterClass;
@property(nonatomic, assign) BOOL                               filterModified;

+ (id)withDelegate:(id<ImageEditViewDelegate>)_delegate;

@end

@protocol ImageEditViewDelegate <NSObject>

@required

- (void)applyFilters:(NSDictionary*)_filters;
- (void)saveFilteredImage:(NSDictionary*)_filters;

@end
