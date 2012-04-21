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

@end

@implementation CalendarMonthAndYearView

@synthesize monthFormatter, yearFormatter, startMonthLabel, endMonthLabel, yearLabel;

#pragma mark -
#pragma mark CalendarMonthAndYearView PrivateAPI

- (void)initializeDateFormatters {
    self.yearFormatter = [[NSDateFormatter alloc] init];
    [self.yearFormatter setDateFormat:@"yyyy"];
    self.monthFormatter = [[NSDateFormatter alloc] init];
    [self.monthFormatter setDateFormat:@"MMMM"];
}

#pragma mark -
#pragma mark CalendarMonthAndYearView

+ (id)withFrame:(CGRect)_frame startDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate {
    return [[CalendarMonthAndYearView alloc] initWithFrame:_frame startDate:_startDate andEndDate:_endDate];
}

- (id)initWithFrame:(CGRect)frame startDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate {
    self = [super initWithFrame:frame];
    if (self) {
        [self initializeDateFormatters];
        [self updateStartDate:_startDate andEndDate:_endDate];
    }
    return self;
}

- (void)updateStartDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate {
    NSString* startMonth = [self.monthFormatter stringFromDate:_startDate];
    self.startMonthLabel.text = startMonth;
    NSString* endMonth = [self.monthFormatter stringFromDate:_endDate];
    self.endMonthLabel.text = endMonth;
    NSString* year = [self.yearFormatter stringFromDate:_startDate];
    self.yearLabel.text = year;
}

@end
