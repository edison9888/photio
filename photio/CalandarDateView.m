//
//  CalandarDateView.m
//  photio
//
//  Created by Troy Stribling on 4/8/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalandarDateView.h"
#import <QuartzCore/QuartzCore.h>

@implementation CalandarDateView

@synthesize dayView;

+ (id)withFrame:(CGRect)_frame andDate:(NSString*)_date {
    return [[CalandarDateView alloc] initWithFrame:_frame andDate:_date];
}

- (id)initWithFrame:(CGRect)_frame andDate:(NSString*)_date {
    self = [super initWithFrame:_frame];
    if (self) {
        self.dayView = [[UITextField alloc] initWithFrame:_frame];
        self.dayView.textAlignment = UITextAlignmentRight;
        self.dayView.text = _date;
        self.dayView.font = [self.dayView.font fontWithSize:DAY_VIEW_DATE_IPHONE_FONT_SIZE];
        self.layer.cornerRadius = 5.0f;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.borderWidth = 1.5f;
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    }
    return self;
}

@end
