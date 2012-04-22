//
//  CalendarEntryView.m
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarEntryView.h"
#import "CalendarDayView.h"
#import "CalendarDayOfWeekView.h"
#import "CalendarDayBackgroundView.h"
#import "ViewGeneral.h"

#define CALENDAR_ENTRY_DATE_OFFSET_FACTOR     0.05f
#define CALENDAR_ENTRY_DATE_SCALE_FACTOR      0.4f
#define CALENDAR_ENTRY_BORDER                 4.0f
#define CALENDAR_ASPECT_RATIO                 1.2

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarEntryView (PrivateAPI)

- (CGRect)calendarDateViewRect:(CGRect)_cotentFrame;
- (void)initializeDateFormatters;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarEntryView

@synthesize dayView, backgroundView, dayOfWeekView, photoView, dayFormatter, dayOfWeekFormatter, date;

#pragma mark -
#pragma mark CalendarEntryView PrivatAPI

- (CGRect)calendarDateViewRect:(CGRect)_cotentFrame {
    CGSize dateViewSize = CGSizeMake(CALENDAR_ENTRY_DATE_SCALE_FACTOR * _cotentFrame.size.width, CALENDAR_ASPECT_RATIO * CALENDAR_ENTRY_DATE_SCALE_FACTOR * _cotentFrame.size.width);
    CGPoint dateViewOffset = CGPointMake(_cotentFrame.size.width - dateViewSize.width * (1.0 + 1.0 * CALENDAR_ENTRY_DATE_OFFSET_FACTOR), dateViewSize.width * CALENDAR_ENTRY_DATE_OFFSET_FACTOR);
    return CGRectMake(dateViewOffset.x, dateViewOffset.y, dateViewSize.width, dateViewSize.height);
}

- (void)initializeDateFormatters {
    self.dayFormatter = [[NSDateFormatter alloc] init];
    [self.dayFormatter setDateFormat:@"d"];
    self.dayOfWeekFormatter = [[NSDateFormatter alloc] init];
    [self.dayOfWeekFormatter setDateFormat:@"EEE"];
}

#pragma mark -
#pragma mark CalendarEntryView

+ (id)withFrame:(CGRect)_frame date:(NSDate*)_date andPhoto:(UIImage*)_photo {
    return [[CalendarEntryView alloc] initWithFrame:_frame date:_date andPhoto:_photo];
}

- (id)initWithFrame:(CGRect)_frame date:(NSDate*)_date andPhoto:(UIImage*)_photo {
    if ((self = [super initWithFrame:_frame])) {
        self.backgroundColor = [UIColor blackColor];
        [self initializeDateFormatters];
        self.date = _date;

        CGRect contentFrame = CGRectMake(CALENDAR_ENTRY_BORDER, CALENDAR_ENTRY_BORDER, self.frame.size.width - CALENDAR_ENTRY_BORDER, self.frame.size.height - CALENDAR_ENTRY_BORDER);
        UIView* contentView = [[UIView alloc] initWithFrame:contentFrame];
        contentView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];

        CGRect dayRect = [self calendarDateViewRect:contentFrame];
        NSString* day = [self.dayFormatter stringFromDate:_date];
        self.dayView = [CalendarDayView withFrame:dayRect andDay:day];
        self.backgroundView = [CalendarDayBackgroundView withFrame:dayRect];
  
        NSString* dayOfWeek = [self.dayOfWeekFormatter stringFromDate:_date];
        self.dayOfWeekView = [CalendarDayOfWeekView withFrame:dayRect andDayOfWeek:dayOfWeek];

        [self addSubview:contentView];
        if (_photo) {   
            self.photoView = [[UIImageView alloc] initWithImage:_photo];
            [contentView addSubview:self.photoView];
        }

        [contentView addSubview:self.backgroundView];
        [contentView addSubview:self.dayView];
        [contentView addSubview:self.dayOfWeekView];
    }
    return self;    
}

@end
