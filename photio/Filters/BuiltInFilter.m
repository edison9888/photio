//
//  BuiltInFilter.m
//  photio
//
//  Created by Troy Stribling on 5/16/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "BuiltInFilter.h" 

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface BuiltInFilter (PrivateAPI)

- (UIImage*)applyFilterForAttributeValue:(id)_value;
- (UIImage*)outputImage;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BuiltInFilter

@synthesize image, filter, filterAttribute, filterAttributeValue;

#pragma mark -
#pragma mark BuiltInFilter PrivateAPI

- (UIImage*)outputImage {
    [self.filter setExposure:self.filterAttributeValue];
    [self.image addTarget:self.filter];
    [self.image processImage];
    return [self.filter imageFromCurrentlyProcessedOutput];
}

- (void)setFilteredImage:(UIImage*)_filteredImage {
    if (!self.image) {
        self.image = [[GPUImagePicture alloc] initWithImage:_filteredImage];
    }
}


#pragma mark -
#pragma mark BuiltInFilter

+ (id)filter:(GPUImageFilter*)_filter withAttribute:(NSString*)_filterAttribute {
    return [[BuiltInFilter alloc] initWithFilter:_filter andAttribute:_filterAttribute];
}

- (id)initWithFilter:(GPUImageFilter*)_filter andAttribute:(NSString*)_filterAttribute {
    self = [super init];
    if (self) {
        self.filter = [[GPUImageExposureFilter alloc] init];
    }
    return self;
}

#pragma mark -
#pragma mark Filter

- (CGFloat)sliderMaxValue {
    return 4.0;
}

- (CGFloat)sliderMinValue {
    return -4.0;
}

- (CGFloat)sliderDefaultValue {
    return 0.0;
}

- (void)setFilterValue:(CGFloat)_value {
    self.filterAttributeValue = _value;
}

- (UIImage*)applyFilterToImage:(UIImage*)_filteredImage {
    [self setFilteredImage:_filteredImage];
    return [self outputImage];
}

@end
