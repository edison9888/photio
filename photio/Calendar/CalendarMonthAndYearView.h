//
//  CalendarMonthAndYearView.h
//  photio
//
//  Created by Troy Stribling on 4/21/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarMonthAndYearViewDelegate;

@interface CalendarMonthAndYearView : UIView {
}

@property(nonatomic, weak)   id<CalendarMonthAndYearViewDelegate>   delegate;
@property(nonatomic, strong) NSDateFormatter*                       monthFormatter;
@property(nonatomic, strong) NSDateFormatter*                       yearFormatter;
@property(nonatomic, strong) UILabel*                               startMonthLabel;
@property(nonatomic, strong) UILabel*                               endMonthLabel;
@property(nonatomic, strong) UILabel*                               yearLabel;
@property(nonatomic, strong) UIFont*                                font;

+ (id)withFrame:(CGRect)_frame delegate:(id<CalendarMonthAndYearViewDelegate>)_delgate startDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate;
- (id)initWithFrame:(CGRect)frame delegate:(id<CalendarMonthAndYearViewDelegate>)_delgate startDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate;
- (void)updateStartDate:(NSDate*)_startDate andEndDate:(NSDate*)_endDate;

@end

@protocol CalendarMonthAndYearViewDelegate <NSObject>

@required

- (void)didTouchCalendarMonthAndYearView;

@end
