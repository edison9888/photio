//
//  CalendarDayView.m
//  photio
//
//  Created by Troy Stribling on 4/8/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarDayView.h"

@implementation CalendarDayView

+ (id)withFrame:(CGRect)_frame andDay:(NSString*)_day {
    return [[CalendarDayView alloc] initWithFrame:_frame andDay:_day];
}

- (id)initWithFrame:(CGRect)_frame andDay:(NSString*)_day {
    CGRect dayFrame = CGRectMake(_frame.origin.x, _frame.origin.y + 0.05*_frame.size.height, 0.9*_frame.size.width, 0.9*_frame.size.height);
    self = [super initWithFrame:dayFrame];
    if (self) {
        self.textAlignment = UITextAlignmentRight;
        self.text = _day;
        self.font = [self.font fontWithSize:0.7*_frame.size.height];
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
