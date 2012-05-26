//
//  VignetteFilter.h
//  photio
//
//  Created by Troy Stribling on 5/26/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuiltInFilter.h"

@interface VignetteFilter : BuiltInFilter

@property(nonatomic, strong) CIFilter* filter;

+ (id)filter;

@end
