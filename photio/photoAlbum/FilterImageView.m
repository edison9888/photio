//
//  FilterImageView.m
//  photio
//
//  Created by Troy Stribling on 5/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "GPUImage.h"
#import "FilterImageView.h"
#import "Filter.h"
#import "NSObject+Extensions.h"
#import "UIImage+Extensions.h"

@interface FilterImageView (PrivateAPI)

- (void)didSelect;
- (UIImage*)createSelectedImage;

@end

@implementation FilterImageView

@synthesize delegate, filter, selectGesture, selected, filterImage, selectedImage;

#pragma mark -
#pragma mark FilterImageView PrivateAPI

- (void)didSelect {
    [self select];
    [self.delegate selectedFilter:self];
}

- (UIImage*)createSelectedImage {
    GPUImagePicture* filteredImage = [[GPUImagePicture alloc] initWithImage:self.filterImage];
    GPUImageFilterGroup* filterGroup = [[GPUImageFilterGroup alloc] init];

    GPUImageFilter* colorOverlayfilter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"WhiteColorOverlay"];
    GPUImageGaussianBlurFilter* gaussainBlur = [[GPUImageGaussianBlurFilter alloc] init];
    [gaussainBlur setBlurSize:1.5f];
    
    [filterGroup addFilter:colorOverlayfilter];
    [filterGroup addFilter:gaussainBlur];
    
    [colorOverlayfilter addTarget:gaussainBlur];
    
    [filterGroup setInitialFilters:[NSArray arrayWithObject:colorOverlayfilter]];
    [filterGroup setTerminalFilter:gaussainBlur];
    
    [filteredImage addTarget:filterGroup];
    [filteredImage processImage];
    
    return [filterGroup imageFromCurrentlyProcessedOutputWithOrientation:self.filterImage.imageOrientation];
}

#pragma mark -
#pragma mark FilterImageView

+ (id)withDelegate:(id<FilterImageViewDelegate>)_delegate andFilter:(Filter*)_filter {
    UIImage* filterImage = [UIImage imageNamed:_filter.imageFilename];
    FilterImageView* view = [[FilterImageView alloc] initWithImage:filterImage];
    view.delegate = _delegate;
    view.filter = _filter;
    return view;
}

- (id)initWithImage:(UIImage*)_image {
    self = [super initWithImage:_image];
    if (self) {
        self.filterImage = _image;
        self.selectedImage = [self createSelectedImage];
        self.userInteractionEnabled = YES;
        self.exclusiveTouch = NO;
        self.selectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect)];
        self.selectGesture.numberOfTapsRequired = 1;
        self.selectGesture.numberOfTouchesRequired = 1;
        self.selectGesture.delegate = self;
        [self addGestureRecognizer:self.selectGesture];
        self.selected = NO;
    }
    return self;
}

- (void)select {
    self.selected = YES;
    self.image = self.selectedImage;
}

- (void)deselect {
    self.selected = NO;
    self.image = self.filterImage;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self nextResponder];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    return YES;
}

@end
