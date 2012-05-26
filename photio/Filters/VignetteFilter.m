//
//  VignetteFilter.m
//  photio
//
//  Created by Troy Stribling on 5/26/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "VignetteFilter.h"

@implementation VignetteFilter

@synthesize filter;

+ (id)filter {
    return [[VignetteFilter alloc] initWithFilter:@"CIVignette" andAttribute:@"inputIntensity"];
}

- (void)setFilterValue:(CGFloat)_value {
    [self.filter setValue:[NSNumber numberWithFloat:2.0] forKey:@"inputRadius"];
    [self.filter setValue:[NSNumber numberWithFloat:_value] forKey:@"inputIntensity"];
}

@end
