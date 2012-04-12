//
//  CalendarDayBackgroundView.m
//  photio
//
//  Created by Troy Stribling on 4/11/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarDayBackgroundView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CalendarDayBackgroundView

+ (id)withFrame:(CGRect)_frame {
    return [[CalendarDayBackgroundView alloc] initWithFrame:_frame];
}

- (id)initWithFrame:(CGRect)_frame {
    self = [super initWithFrame:_frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0f;
    }
    return self;
}

@end
