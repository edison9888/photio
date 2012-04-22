//
//  CalendarDayOfWeekView.m
//  photio
//
//  Created by Troy Stribling on 4/15/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarDayOfWeekView.h"

@implementation CalendarDayOfWeekView

+ (id)withFrame:(CGRect)_frame andDayOfWeek:(NSString*)_dayOfWeek {
    return [[CalendarDayOfWeekView alloc] initWithFrame:_frame andDayOfWeek:_dayOfWeek];
}

- (id)initWithFrame:(CGRect)_frame andDayOfWeek:(NSString*)_dayOfWeek {
    CGRect dayFrame = CGRectMake(_frame.origin.x + 0.15 * _frame.size.width, _frame.origin.y + 0.025*_frame.size.height, 0.9*_frame.size.width, 0.35*_frame.size.height);
    self = [super initWithFrame:dayFrame];
    if (self) {
        self.textAlignment = UITextAlignmentLeft;
        self.text = _dayOfWeek;
        self.font = [self.font fontWithSize:0.3*_frame.size.height];
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
