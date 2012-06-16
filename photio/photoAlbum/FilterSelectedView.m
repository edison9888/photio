//
//  FilterSelectedView.m
//  photio
//
//  Created by Troy Stribling on 6/16/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "FilterSelectedView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FilterSelectedView

+ (id)withFrame:(CGRect)_frame {
    return [[FilterSelectedView alloc] initWithFrame:_frame];
}

- (id)initWithFrame:(CGRect)_frame { 
    self = [super initWithFrame:_frame];
    if (self) {
        self.layer.cornerRadius = 2.0f;
        self.layer.backgroundColor = [UIColor colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.85f].CGColor;
    }
    return self;
}

@end
