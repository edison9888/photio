//
//  CalendarMonthAndYearView.m
//  photio
//
//  Created by Troy Stribling on 4/21/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarMonthAndYearView.h"

@interface CalendarMonthAndYearView (PrivateAPI)

- (void)initializeDateFormatters;
- (void)initializeViews;
- (void)scrollCalendarToTop;

@end

@implementation CalendarMonthAndYearView

@synthesize monthFormatter, yearFormatter, startMonthLabel, endMonthLabel, yearLabel, font, delegate;

#pragma mark -
#pragma mark CalendarMonthAndYearView PrivateAPI

- (void)initializeDateFormatters {
    self.yearFormatter = [[NSDateFormatter alloc] init];
    [self.yearFormatter setDateFormat:@"yyyy"];
    self.monthFormatter = [[NSDateFormatter alloc] init];
    [self.monthFormatter setDateFormat:@"MMMM"];
}

- (void)initializeViews {
    CGFloat xOffset = 10.0/320.0;
    CGFloat yOffset = 2.0/30.0;
    CGSize monthSize = CGSizeMake(100.0/320.0, 25.0/30.0);
    CGRect startMonthRect = CGRectMake(xOffset*self.frame.size.width, yOffset*self.frame.size.height, monthSize.width*self.frame.size.width, monthSize.height*self.frame.size.height);
    self.startMonthLabel = [[UILabel alloc] initWithFrame:startMonthRect];
    self.startMonthLabel.textColor = [UIColor grayColor];
    self.startMonthLabel.backgroundColor = [UIColor blackColor];
    self.startMonthLabel.textAlignment = UITextAlignmentLeft;
    [self addSubview:self.startMonthLabel];
    self.startMonthLabel.font = self.font;

    xOffset = 5.0/320.0;
    CGRect endMonthRect = CGRectMake((1.0-xOffset-monthSize.width)*self.frame.size.width, yOffset*self.frame.size.height, monthSize.width*self.frame.size.width, monthSize.height*self.frame.size.height);
    self.endMonthLabel = [[UILabel alloc] initWithFrame:endMonthRect];
    self.endMonthLabel.textColor = [UIColor grayColor];
    self.endMonthLabel.textAlignment = UITextAlignmentRight;
    self.endMonthLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:self.endMonthLabel];
    self.endMonthLabel.font = self.font;

    yOffset = 5.0/30.0;
    CGSize yearSize = CGSizeMake(60.0/320.0, 20.0/30.0);
    self.yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width*(1.0-yearSize.width)/2.0, yOffset*self.frame.size.height, yearSize.width*self.frame.size.width, yearSize.height*self.frame.size.height)];
    self.yearLabel.textColor = [UIColor grayColor];
    self.yearLabel.textAlignment = UITextAlignmentCenter;
    self.yearLabel.backgroundColor = [UIColor blackColor];
    [self addSubview:self.yearLabel];
    self.yearLabel.font = self.font;
}

- (void)didTouch {
    [self.delegate didTouchCalendarMonthAndYearView];
}

#pragma mark -
#pragma mark CalendarMonthAndYearView

+ (id)withFrame:(CGRect)_frame delegate:(id<CalendarMonthAndYearViewDelegate>)_delegate startDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate {
    return [[CalendarMonthAndYearView alloc] initWithFrame:_frame delegate:_delegate  startDate:_startDate andEndDate:_endDate];
}

- (id)initWithFrame:(CGRect)_frame delegate:(id<CalendarMonthAndYearViewDelegate>)_delgate startDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate {
    self = [super initWithFrame:_frame];
    if (self) {
        self.delegate = _delgate;
        self.font = [UIFont boldSystemFontOfSize:0.75*self.frame.size.height];
        self.userInteractionEnabled = YES;
        [self initializeDateFormatters];
        [self initializeViews];
        [self updateStartDate:_startDate andEndDate:_endDate];
        UITapGestureRecognizer* scrollToTop = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch)];
        scrollToTop.numberOfTouchesRequired = 1;
        scrollToTop.numberOfTapsRequired = 1;
        [self addGestureRecognizer:scrollToTop];
    }
    return self;
}

- (void)updateStartDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate {
    NSString* startMonth = [self.monthFormatter stringFromDate:_startDate];
    self.startMonthLabel.text = startMonth;
    NSString* endMonth = [self.monthFormatter stringFromDate:_endDate];
    if ([startMonth isEqualToString:endMonth]) {
        self.endMonthLabel.text = NULL;
    } else {
        self.endMonthLabel.text = endMonth;
    }
    NSString* year = [self.yearFormatter stringFromDate:_startDate];
    self.yearLabel.text = year;
}

@end
