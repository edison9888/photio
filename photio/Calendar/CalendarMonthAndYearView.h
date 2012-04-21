//
//  CalendarMonthAndYearView.h
//  photio
//
//  Created by Troy Stribling on 4/21/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarMonthAndYearView : UIView {
}

@property(nonatomic, strong) NSDateFormatter*   monthFormatter;
@property(nonatomic, strong) NSDateFormatter*   yearFormatter;
@property(nonatomic, strong) UILabel*           startMonthLabel;
@property(nonatomic, strong) UILabel*           endMonthLabel;
@property(nonatomic, strong) UILabel*           yearLabel;

+ (id)withFrame:(CGRect)_frame startDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate;
- (id)initWithFrame:(CGRect)frame startDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate;
- (void)updateStartDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate;

@end
