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
#import "ParameterSelectionView.h"
#import "UIView+Extensions.h"
#import "Filter.h"
#import "FilterPalette.h"
#import "FilterImageView.h"

#define SAVE_FILTERED_IMAGE_ALPHA               0.3
#define SAVE_FILTETRED_IMAGE_SELECTED_ALPHA     0.8
#define EDIT_VIEW_ANIMATION_DURATION            0.2

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEditView (PrivateAPI)

- (void)selectFilter:(FilterImageView*)_filterImage;
- (void)setFilterParameters;
- (IBAction)saveFilteredImage:(id)sender;
- (IBAction)changeFilterPalette:(id)sender;
- (void)updateFilterViewsForFilterPalette:(FilterPalette*)_filterPalette;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEditView

@synthesize delegate, containerView, controlContainerView, filterContainerView, parameterSlider, imageSaveFilteredImageView, imageFilterPaletteView,
            imageFiltersView, filterPaletteSelectionView, displayedFilterImage, isInitialized;

#pragma mark -
#pragma mark ImageEditView (PrivateAPI)

- (void)selectFilter:(FilterImageView*)_filterImage {
    self.displayedFilterImage = _filterImage;
    [self setFilterParameters];
    [self.delegate applyFilter:self.displayedFilterImage.filter withValue:self.displayedFilterImage.filter.defaultValue];
}

- (void)setFilterParameters {
    self.parameterSlider.maxValue = [self.displayedFilterImage.filter.maximumValue floatValue];
    self.parameterSlider.minValue = [self.displayedFilterImage.filter.minimumValue floatValue];
    self.parameterSlider.initialValue = [self.displayedFilterImage.filter.defaultValue floatValue];
    [self.parameterSlider setParameterSliderValue];    
}

- (IBAction)changeFilterPalette:(id)sender {
    CGRect controlViewRect = self.controlContainerView.frame;
    CGRect filterViewRect = self.filterContainerView.frame;
    __block CGRect showControlViewRect = CGRectMake(controlViewRect.origin.x, -controlViewRect.size.height, controlViewRect.size.width, controlViewRect.size.height);
    __block CGRect showFilterlViewRect = CGRectMake(filterViewRect.origin.x, self.frame.size.height, filterViewRect.size.width, filterViewRect.size.height);
    __block CGRect hideControlViewRect = CGRectMake(controlViewRect.origin.x, 0.0, controlViewRect.size.width, controlViewRect.size.height);
    __block CGRect hideFilterlViewRect = CGRectMake(filterViewRect.origin.x, self.frame.size.height - filterViewRect.size.height, filterViewRect.size.width, filterViewRect.size.height);
    self.filterPaletteSelectionView = [ParameterSelectionView initInView:self 
        withDelegate:self 
        showAnimation:^{
            self.controlContainerView.frame = showControlViewRect;
            self.filterContainerView.frame = showFilterlViewRect;
        }
        hideAnimation:^{
            [UIView animateWithDuration:EDIT_VIEW_ANIMATION_DURATION
                animations:^{
                    self.controlContainerView.frame = hideControlViewRect;
                    self.filterContainerView.frame = hideFilterlViewRect;
                } 
                completion:^(BOOL _finished) {
                }
             ];
        }
        andTitle:@"Palettes"
    ];
}

- (IBAction)saveFilteredImage:(id)sender {
    self.imageSaveFilteredImageView.alpha = SAVE_FILTERED_IMAGE_ALPHA; 
    self.imageSaveFilteredImageView.userInteractionEnabled = NO;
    [self.delegate saveFilteredImage:self.displayedFilterImage.filter withValue:[NSNumber numberWithFloat:[self.parameterSlider value]]];
    [self.delegate resetFilteredImage];
    [self selectFilter:self.displayedFilterImage];
}

- (void)updateFilterViewsForFilterPalette:(FilterPalette*)_filterPalette {
    self.imageFilterPaletteView.image = [UIImage imageNamed:_filterPalette.imageFilename];
    [self.imageFiltersView addFilterViewsForFilterPalette:_filterPalette];
    Filter* defaultFilter = [[FilterFactory instance] defaultFilterForPalette:_filterPalette];
    FilterImageView* defaultFilterImage = [self.imageFiltersView filterImageViewForFilter:defaultFilter];
    [defaultFilterImage select];
    [self selectFilter:defaultFilterImage];
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
        self.imageFiltersView.filtersViewDelegate = self;
        [self updateFilterViewsForFilterPalette:[[FilterFactory instance] defaultFilterPalette]];
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

#pragma mark -
#pragma mark ParameterSelectionViewDelegate

- (NSArray*)loadParameters {
    return [[FilterFactory instance] filterPalettes];
}

- (void)configureParemeterCell:(ParameterSelectionCell*)_parameterCell withParameter:(id)_parameter {
    _parameterCell.parameterIcon.image = [UIImage imageNamed:[_parameter valueForKey:@"imageFilename"]];
    _parameterCell.parameterLabel.text = [_parameter valueForKey:@"name"];
}

- (void)selectedParameter:(id)_parameter {
    [self.imageFiltersView removeFilterViews];
    FilterPalette* displayedFilterPalette = _parameter;
    [self updateFilterViewsForFilterPalette:displayedFilterPalette];
    [self.filterPaletteSelectionView removeView];
}


@end
