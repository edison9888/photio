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

@synthesize context, filter, image, filterAttribute;

#pragma mark -
#pragma mark BuiltInFilter PrivateAPI

- (UIImage*)outputImage {
    CIImage* outputImage = [self.filter outputImage];
    CGImageRef cgImageRef = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage* outputUIImage = [UIImage imageWithCGImage:cgImageRef];
    CGImageRelease(cgImageRef);
    return outputUIImage;
}

- (void)setFilteredImage:(UIImage*)_filteredImage {
    if (!self.image) {
        self.image = [[CIImage alloc] initWithImage:_filteredImage];
        [self.filter setValue:self.image forKey:@"inputImage"];
    }
}

#pragma mark -
#pragma mark BuiltInFilter

+ (id)filter:(NSString*)_filterName andAttribute:(NSString*)_attribute {
    return [[BuiltInFilter alloc] initWithFilter:_filterName andAttribute:_attribute];
}

- (id)initWithFilter:(NSString*)_filterName andAttribute:(NSString*)_attribute {
    self = [super init];
    if (self) {
        self.context = [CIContext contextWithOptions:nil];
        self.filter = [CIFilter filterWithName:_filterName];
        self.filterAttribute = _attribute;
    }
    return self;
}

#pragma mark -
#pragma mark Filter

- (CGFloat)sliderMaxValue {
    NSDictionary* filterAttributes = [self.filter attributes];
    NSNumber* maxValue = [[filterAttributes objectForKey:self.filterAttribute] objectForKey:kCIAttributeSliderMax];
    return [maxValue doubleValue];
}

- (CGFloat)sliderMinValue {
    NSDictionary* filterAttributes = [self.filter attributes];
    NSNumber* minValue = [[filterAttributes objectForKey:self.filterAttribute] objectForKey:kCIAttributeSliderMin];
    return [minValue doubleValue];
}

- (CGFloat)sliderDefaultValue {
    NSDictionary* filterAttributes = [self.filter attributes];
    NSNumber* defaultValue = [[filterAttributes objectForKey:self.filterAttribute] objectForKey:kCIAttributeDefault];
    return [defaultValue doubleValue];
    
}

- (UIImage*)applyFilterToImage:(UIImage*)_filteredImage withAttributeValue:(id)_value {
    [self setFilteredImage:_filteredImage];
    [self.filter setValue:_value forKey:self.filterAttribute];
    return [self outputImage];
}

@end
