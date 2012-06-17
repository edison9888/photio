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
#import "ParameterSelectionView.h"

@class ImageControlView;
@class ParameterSliderView;
@class FilterPalette;
@class Filter;
@class FilterImageView;

@protocol ImageEditViewDelegate;

@interface ImageEditView : UIView <ParameterSliderViewDelegate, ImageFiltersViewDelegate, ParameterSelectionViewDelegate>

@property(nonatomic, weak)   id<ImageEditViewDelegate>          delegate;
@property(nonatomic, strong) UIView*                            containerView;
@property(nonatomic, strong) IBOutlet UIView*                   controlContainerView;
@property(nonatomic, strong) IBOutlet UIView*                   filterContainerView;
@property(nonatomic, strong) IBOutlet ParameterSliderView*      parameterSlider;
@property(nonatomic, strong) IBOutlet UIImageView*              imageSaveFilteredImageView;
@property(nonatomic, strong) IBOutlet UIImageView*              imageFilterPaletteView;
@property(nonatomic, strong) IBOutlet ImageFiltersView*         imageFiltersView;
@property(nonatomic, strong) ParameterSelectionView*            filterPaletteSelectionView;
@property(nonatomic, assign) FilterImageView*                   displayedFilterImage;
@property(nonatomic, assign) BOOL                               isInitialized;

+ (id)withDelegate:(id<ImageEditViewDelegate>)_delegate;

@end

@protocol ImageEditViewDelegate <NSObject>

@required

- (void)applyFilter:(Filter*)_filter withValue:(NSNumber*)_value;
- (void)saveFilteredImage:(Filter*)_filter withValue:(NSNumber*)_value;
- (void)resetFilteredImage;

@end
