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
#import "FilterFactory.h"
#import "ImageFilterClassView.h"
#import "UIView+Extensions.h"
#import "FilterClassUsage.h"
#import "FilterImageView.h"
#import "FilterUsage.h"
#import "Filter.h"

#define SAVE_FILTERED_IMAGE_ALPHA               0.3
#define SAVE_FILTETRED_IMAGE_SELECTED_ALPHA     0.8

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEditView (PrivateAPI)

- (void)selectFilter:(FilterImageView*)_filterImage;
- (void)setFilterParameters;
- (IBAction)saveFilteredImage:(id)sender;
- (IBAction)changeFilterClass:(id)sender;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEditView

@synthesize delegate, containerView, controlContainerView, filterContainerView, parameterSlider, imageSaveFilteredImageView, imageFilterClassView,
            imageFiltersView, filterToApply, displayedFilterImage, displayedFilterClass, isInitialized;

#pragma mark -
#pragma mark ImageEditView (PrivateAPI)

- (void)selectFilter:(FilterImageView*)_filterImage {
    self.displayedFilterImage = _filterImage;
    self.filterToApply = [FilterFactory filter:_filterImage.filter];
    [self setFilterParameters];
}

- (void)setFilterParameters {
    self.parameterSlider.maxValue = [self.filterToApply sliderMaxValue];
    self.parameterSlider.minValue = [self.filterToApply sliderMinValue];
    self.parameterSlider.initialValue = [self.filterToApply sliderDefaultValue];
    [self.parameterSlider setIntialValue];    
}

- (IBAction)changeFilterClass:(id)sender {
    ImageFilterClassView* filterClassView = [ImageFilterClassView initInView:self];
    [self addSubview:filterClassView];
}

- (IBAction)saveFilteredImage:(id)sender {
    self.imageSaveFilteredImageView.alpha = SAVE_FILTERED_IMAGE_ALPHA; 
    self.imageSaveFilteredImageView.userInteractionEnabled = NO;
    [self.delegate saveFilteredImage:self.filterToApply];
    [self.delegate resetFilteredImage];
    [self selectFilter:self.displayedFilterImage];
}

#pragma mark -
#pragma mark ImageEditView

+ (id)withDelegate:(id<ImageEditViewDelegate>)_delegate {
    ImageEditView* view = (ImageEditView*)[UIView loadView:[self class]];
    view.delegate = _delegate;
    view.parameterSlider.delegate = view;
    return view;
}

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
        self.isInitialized = NO;
    }
    return self;
}

- (void)didMoveToSuperview {
    if (!self.isInitialized) {
        self.imageSaveFilteredImageView.userInteractionEnabled = NO;
        self.isInitialized = YES;
        FilterFactory* filterFactory = [FilterFactory instance];
        self.displayedFilterClass = [filterFactory defaultFilterClass];
        self.imageFilterClassView.image = [UIImage imageNamed:self.displayedFilterClass.imageFilename];
        self.imageFiltersView.filtersViewDelegate = self;
        self.imageFiltersView.filterClass = self.displayedFilterClass;
        [self.imageFiltersView addFilterViews];
        FilterUsage* defaultFilter = [filterFactory defaultFilter:self.displayedFilterClass];
        FilterImageView* defaultFilterImage = [self.imageFiltersView filterImageViewForFilter:defaultFilter];
        [defaultFilterImage select];
        [self selectFilter:defaultFilterImage];
    }
}

#pragma mark -
#pragma mark ParameterSliderViewDelegate

- (void)parameterSliderValueChanged:(ParameterSliderView *)_parameterSlider {
    CGFloat value = [_parameterSlider value];
    [self.filterToApply setFilterValue:value];
    self.imageSaveFilteredImageView.alpha = SAVE_FILTETRED_IMAGE_SELECTED_ALPHA;
    self.imageSaveFilteredImageView.userInteractionEnabled = YES;
    [self.delegate applyFilter:self.filterToApply];
}

#pragma mark -
#pragma mark ImageFiltersViewDelegate

- (void)selectedFilter:(FilterImageView*)_filterImage {
    [self.displayedFilterImage deselect];
    [self.delegate resetFilteredImage];
    [self selectFilter:_filterImage];
}

@end
