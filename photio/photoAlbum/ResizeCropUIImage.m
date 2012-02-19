//
//  ResizeCropUIImage.m
//  weightTrek
//
//  Created by Troy Stribling on 2/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ResizeCropUIImage.h"
#import "math.h"
static inline double radians (double degrees) {return degrees * M_PI/180;}

@implementation UIImage (ResizeCropUIImage)

- (UIImage*)scaleBy:(CGFloat)_scaleFactor andCropWithRect:(CGRect)_rect {
    
    CGSize scaledSize = CGSizeMake(roundf(_scaleFactor*self.size.width), roundf(_scaleFactor*self.size.height));
    
    UIGraphicsBeginImageContext(scaledSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, CGRectMake(0, 0, scaledSize.width, scaledSize.height), self.CGImage);
    UIImage* outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
//    if (_rect.origin.x >= scaledSize.width || _rect.origin.y >= scaledSize.height) return outputImage;
//    if (_rect.origin.x + _rect.size.width >= self.size.width) _rect.size.width = self.size.width - _rect.origin.x;
//    if (_rect.origin.y + _rect.size.height >= self.size.height) _rect.size.height = self.size.height - _rect.origin.y;
//    
//    CGImageRef imageRef;
//    if ((imageRef = CGImageCreateWithImageInRect(outputImage.CGImage, _rect))) {
//        outputImage = [UIImage imageWithCGImage: imageRef];
//        CGImageRelease(imageRef);
//    }
    
    return outputImage;
}

-(UIImage*)resize:(CGSize)_size {	
	CGImageRef imageRef = [self CGImage];
	CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGColorSpaceCreateDeviceRGB();
	
	if (alphaInfo == kCGImageAlphaNone)
		alphaInfo = kCGImageAlphaNoneSkipLast;
	
	CGContextRef bitmap;	
	if (self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown) {
		bitmap = CGBitmapContextCreate(NULL, _size.width, _size.height, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);		
	} else {
		bitmap = CGBitmapContextCreate(NULL, _size.height, _size.width, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, alphaInfo);
	}
	
	if (self.imageOrientation == UIImageOrientationLeft) {
		CGContextRotateCTM(bitmap, radians(90));
		CGContextTranslateCTM(bitmap, 0, -_size.height);
	} else if (self.imageOrientation == UIImageOrientationRight) {
		CGContextRotateCTM(bitmap, radians(-90));
		CGContextTranslateCTM(bitmap, -_size.width, 0);
	} else if (self.imageOrientation == UIImageOrientationUp) {
	} else if (self.imageOrientation == UIImageOrientationDown) {
		CGContextTranslateCTM(bitmap, _size.width, _size.height);
		CGContextRotateCTM(bitmap, radians(-180.));
	}
	
	CGContextDrawImage(bitmap, CGRectMake(0, 0, _size.width, _size.height), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage *result = [UIImage imageWithCGImage:ref];
	
	CGColorSpaceRelease(colorSpaceInfo);
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return result;	
}

@end
