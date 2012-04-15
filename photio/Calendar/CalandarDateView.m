//
//  CalandarDateView.m
//  photio
//
//  Created by Troy Stribling on 4/8/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalandarDateView.h"

@implementation CalandarDateView

+ (id)withFrame:(CGRect)_frame andDate:(NSString*)_date {
    return [[CalandarDateView alloc] initWithFrame:_frame andDate:_date];
}

- (id)initWithFrame:(CGRect)_frame andDate:(NSString*)_date {
    CGRect dayFrame = CGRectMake(_frame.origin.x, _frame.origin.y + 0.05*_frame.size.height, 0.9*_frame.size.width, 0.9*_frame.size.height);
    self = [super initWithFrame:dayFrame];
    if (self) {
        self.textAlignment = UITextAlignmentRight;
        self.text = _date;
        self.font = [self.font fontWithSize:0.7*_frame.size.height];
        self.textColor = [UIColor whiteColor];
    }
    return self;
}

@end
