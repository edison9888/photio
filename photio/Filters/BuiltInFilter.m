//
//  BuiltInFilter.m
//  photio
//
//  Created by Troy Stribling on 5/16/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "BuiltInFilter.h" 

@implementation BuiltInFilter

@synthesize context, filter, image;

+ (id)filter:(NSString*)_filterName withImage:(UIImage*)_image {
    return [[BuiltInFilter alloc] initWithFilter:_filterName image:_image];
}

- (id)initWithFilter:(NSString*)_filterName image:(UIImage*)_image {
    self = [super init];
    if (self) {
        self.context = [CIContext contextWithOptions:nil];
        self.image = [[CIImage alloc] initWithImage:_image];
        self.filter = [CIFilter filterWithName:_filterName keysAndValues:kCIInputImageKey, self.image, nil];
    }
    return self;
}

- (UIImage*)applyFilterForValue:(id)_value andKey:(NSString*)_key; {
    [self.filter setValue:_value forKey:_key];
    return [self outputImage];
}

- (void)setValue:(id)_value forKey:(NSString*)_key {
    [self.filter setValue:_value forKey:_key];
}

- (UIImage*)outputImage {
    CIImage* outputImage = [self.filter outputImage];
    CGImageRef cgImageRef = [self.context createCGImage:outputImage fromRect:[outputImage extent]];
    UIImage* outputUIImage = [UIImage imageWithCGImage:cgImageRef];
    CGImageRelease(cgImageRef);
    return outputUIImage;
}


@end
