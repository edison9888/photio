//
//  BuiltInFilter.h
//  photio
//
//  Created by Troy Stribling on 5/16/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"
#import "Filter.h"

@interface BuiltInFilter : Filter

@property(nonatomic, strong) GPUImagePicture*               image;
//@property(nonatomic, strong) GPUImageOutput<GPUImageInput>* filter;
@property(nonatomic, strong) GPUImageExposureFilter*        filter;
@property(nonatomic, assign) NSString*                      filterAttribute;
@property(nonatomic, assign) CGFloat                        filterAttributeValue;

+ (id)filter:(GPUImageFilter*)_filter withAttribute:(NSString*)_filterAttribute;
- (id)initWithFilter:(GPUImageFilter*)_filter andAttribute:(NSString*)_filterAttribute;

@end

