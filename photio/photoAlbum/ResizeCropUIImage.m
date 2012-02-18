//
//  ResizeCropUIImage.m
//  weightTrek
//
//  Created by Troy Stribling on 2/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ResizeCropUIImage.h"

@implementation UIImage (ResizeCropUIImage)

- (UIImage*)scaleBy:(CGFloat)_scaleFactor andCropWithRect:(CGRect)_rect {
    
    CGSize scaledSize = CGSizeMake(roundf(_scaleFactor*self.size.width), roundf(_scaleFactor*self.size.height));
    
    UIGraphicsBeginImageContext(scaledSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, CGRectMake(0, 0, scaledSize.width, scaledSize.height), self.CGImage);
    UIImage* outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (_rect.origin.x >= scaledSize.width || _rect.origin.y >= scaledSize.height) return outputImage;
    if (_rect.origin.x + _rect.size.width >= self.size.width) _rect.size.width = self.size.width - _rect.origin.x;
    if (_rect.origin.y + _rect.size.height >= self.size.height) _rect.size.height = self.size.height - _rect.origin.y;
    
    CGImageRef imageRef;
    if ((imageRef = CGImageCreateWithImageInRect(outputImage.CGImage, _rect))) {
        outputImage = [UIImage imageWithCGImage: imageRef];
        CGImageRelease(imageRef);
    }
    
    return outputImage;
}

@end
