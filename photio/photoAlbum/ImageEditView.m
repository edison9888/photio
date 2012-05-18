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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEditView (PrivateAPI)

- (void)filterParameters:(NSString*)_filterName;
- (void)addFilter:(NSString*)_filterName withAttribute:(NSString*)_attributeName;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEditView

@synthesize delegate, containerView, controlContainerView, filterContainerView, parameterSlider, imageControlsView, imageFiltersView,
            filtersToApply, filtersLoaded, displayedFilter, displayedFilterClass, displayedFilterLoaded;

#pragma mark -
#pragma mark ImageEditView (PrivateAPI)

- (void)filterParameters:(NSString*)_filterName {
    
}

- (void)addFilter:(NSString*)_filterName withAttribute:(NSString*)_attributeName {
    
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

#pragma mark -
#pragma mark ParameterSliderViewDelegate

- (void)parameterSliderValueChanged:(ParameterSliderView *)_parameterSlider {
}

@end
