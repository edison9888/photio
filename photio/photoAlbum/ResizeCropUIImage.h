//
//  ResizeCropUIImage.h
//  weightTrek
//
//  Created by Troy Stribling on 2/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UIImage (ResizeCropUIImage)

- (UIImage*)scaleBy:(CGFloat)_scale andCropWithRect:(CGRect)_rectt;

@end
