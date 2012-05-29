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
#import "ImageFilterPaletteView.h"
#import "UIView+Extensions.h"
#import "Filter.h"
#import "FilterPalette.h"
#import "FilterImageView.h"

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

@synthesize delegate, containerView, controlContainerView, filterContainerView, parameterSlider, imageSaveFilteredImageView, imageFilterPaletteView,
            imageFiltersView, displayedFilterImage, displayedFilterPalette, isInitialized;

#pragma mark -
#pragma mark ImageEditView (PrivateAPI)

- (void)selectFilter:(FilterImageView*)_filterImage {
    self.displayedFilterImage = _filterImage;
    [self setFilterParameters];
}

- (void)setFilterParameters {
    self.parameterSlider.maxValue = [self.displayedFilterImage.filter.maximumValue floatValue];
    self.parameterSlider.minValue = [self.displayedFilterImage.filter.minimumValue floatValue];
    self.parameterSlider.initialValue = [self.displayedFilterImage.filter.defaultValue floatValue];
    [self.parameterSlider setIntialValue];    
}

- (IBAction)changeFilterClass:(id)sender {
    ImageFilterPaletteView* filterPaletteView = [ImageFilterPaletteView initInView:self];
    [self addSubview:filterPaletteView];
}

- (IBAction)saveFilteredImage:(id)sender {
    self.imageSaveFilteredImageView.alpha = SAVE_FILTERED_IMAGE_ALPHA; 
    self.imageSaveFilteredImageView.userInteractionEnabled = NO;
    [self.delegate saveFilteredImage:self.displayedFilterImage.filter withValue:[NSNumber numberWithFloat:[self.parameterSlider value]]];
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
        self.displayedFilterPalette = [filterFactory defaultFilterPalette];
        self.imageFilterPaletteView.image = [UIImage imageNamed:self.displayedFilterPalette.imageFilename];
        self.imageFiltersView.filtersViewDelegate = self;
        self.imageFiltersView.filterPalette = self.displayedFilterPalette;
        [self.imageFiltersView addFilterViews];
        Filter* defaultFilter = [filterFactory defaultFilterForPalette:self.displayedFilterPalette];
        FilterImageView* defaultFilterImage = [self.imageFiltersView filterImageViewForFilter:defaultFilter];
        [defaultFilterImage select];
        [self selectFilter:defaultFilterImage];
    }
}

#pragma mark -
#pragma mark ParameterSliderViewDelegate

- (void)parameterSliderValueChanged:(ParameterSliderView *)_parameterSlider {
    self.imageSaveFilteredImageView.alpha = SAVE_FILTETRED_IMAGE_SELECTED_ALPHA;
    self.imageSaveFilteredImageView.userInteractionEnabled = YES;
    [self.delegate applyFilter:self.displayedFilterImage.filter withValue:[NSNumber numberWithFloat:[_parameterSlider value]]];
}

#pragma mark -
#pragma mark ImageFiltersViewDelegate

- (void)selectedFilter:(FilterImageView*)_filterImage {
    [self.displayedFilterImage deselect];
    [self.delegate resetFilteredImage];
    [self selectFilter:_filterImage];
}

@end
