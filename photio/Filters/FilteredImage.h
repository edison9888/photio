//
//  FilteredImage.h
//  photio
//
//  Created by Troy Stribling on 5/16/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilteredImage : NSObject

@property(nonatomic, strong) CIContext*                 context;
@property(nonatomic, strong) CIFilter*                  filter;
@property(nonatomic, strong) CIImage*                   image;

+ (id)filter:(NSString*)_filterName withImage:(UIImage*)_image;
- (id)initWithFilter:(NSString*)_filterName image:(UIImage*)_image;
- (UIImage*)applyFilterForValue:(id)_value andKey:(NSString*)_key;
- (void)setValue:(id)_value forKey:(NSString*)_key;
- (UIImage*)outputImage;

@end

