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
#import "FilterFactory.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEditView (PrivateAPI)

- (void)filterParameters:(NSString*)_filterName;
- (void)addFilter:(NSString*)_filterName withAttribute:(NSString*)_attributeName;
- (void)removeFilter:(FilterType)_filterType;
- (IBAction)applyFilter:(id)sender;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEditView

@synthesize delegate, containerView, controlContainerView, filterContainerView, parameterSlider, imageControlsView, imageFiltersView,
            filtersToApply, filtersLoaded, displayedFilter, displayedFilterClass, displayedFilterLoaded;

#pragma mark -
#pragma mark ImageEditView (PrivateAPI)

- (void)filterParameters:(NSString*)_filterName {
}

- (void)addFilter:(FilterType)_filterType {
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
        self.filtersLoaded = [NSMutableDictionary dictionaryWithCapacity:10];
    }
    return self;
}

- (void)didMoveToSuperview {
    [self addFilter:FilterTypeVibrance];
}

- (IBAction)applyFilter:(id)sender {
    
}

#pragma mark -
#pragma mark ParameterSliderViewDelegate

- (void)parameterSliderValueChanged:(ParameterSliderView *)_parameterSlider {
}

@end
