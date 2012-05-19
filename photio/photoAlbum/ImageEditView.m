//
//  ImageEditView.m
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageEditView.h"
#import "ImageControlView.h"
#import "ParameterSliderView.h"
#import "UIView+Extensions.h"

#define SAVE_FILTERED_IMAGE_ALPHA               0.3
#define SAVE_FILTETRED_IMAGE_SELECTED_ALPHA     0.8

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEditView (PrivateAPI)

- (void)filterParameters:(NSString*)_filterName;
- (void)addFilter:(NSString*)_filterName withAttribute:(NSString*)_attributeName;
- (void)removeFilter:(FilterType)_filterType;
- (IBAction)saveFilteredImage:(id)sender;
- (IBAction)changeFilterClass:(id)sender;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEditView

@synthesize delegate, containerView, controlContainerView, filterContainerView, parameterSlider, imageSaveFilteredImageView, imageFilterClassView,
            filtersToApply, displayedFilter, displayedFilterClass, filterModified;

#pragma mark -
#pragma mark ImageEditView (PrivateAPI)

- (void)filterParameters:(NSString*)_filterName {
}

- (void)addFilter:(FilterType)_filterType {
    self.displayedFilter = _filterType;
    Filter* filter = [FilterFactory filter:_filterType];
    self.parameterSlider.maxValue = [filter sliderMaxValue];
    self.parameterSlider.minValue = [filter sliderMinValue];
    self.parameterSlider.initialValue = [filter sliderDefaultValue];
    [self.parameterSlider setUp];
    [self.filtersToApply setObject:filter forKey:[NSNumber numberWithInt:_filterType]];
}

- (void)removeFilter:(FilterType)_filterType {
    [self.filtersToApply removeObjectForKey:[NSNumber numberWithInt:_filterType]];
}

- (IBAction)changeFilterClass:(id)sender {
    
}

- (IBAction)saveFilteredImage:(id)sender {
    if (self.filterModified) {
        self.imageSaveFilteredImageView.alpha = SAVE_FILTERED_IMAGE_ALPHA;  
        [self.delegate saveFilteredImage:self.filtersToApply];
    }
}

#pragma mark -
#pragma mark ImageEditView

+ (id)inView:(UIView*)_containerView withDelegate:(id<ImageEditViewDelegate>)_delegate {
    ImageEditView* view = (ImageEditView*)[UIView loadView:[self class]];
    view.delegate = _delegate;
    view.parameterSlider.delegate = view;
    return view;
}

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
        self.filtersToApply = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

- (void)didMoveToSuperview {
    [self addFilter:FilterTypeSaturation];
}

#pragma mark -
#pragma mark ParameterSliderViewDelegate

- (void)parameterSliderValueChanged:(ParameterSliderView *)_parameterSlider {
    Filter* filter = [self.filtersToApply objectForKey:[NSNumber numberWithInt:self.displayedFilter]];
    CGFloat value = [_parameterSlider value];
    [filter setFilterValue:value];
    self.imageSaveFilteredImageView.alpha = SAVE_FILTETRED_IMAGE_SELECTED_ALPHA;
    self.filterModified = YES;
    [self.delegate applyFilters:self.filtersToApply];
}

@end
