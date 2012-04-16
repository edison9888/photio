//
//  CalendarEntryView.m
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarEntryView.h"
#import "CalandarDateView.h"
#import "CalendarDayOfWeekView.h"
#import "CalendarDayBackgroundView.h"
#import "ViewGeneral.h"

#define CALENDAR_ENTRY_DATE_OFFSET_FACTOR     0.05f
#define CALENDAR_ENTRY_DATE_SCALE_FACTOR      0.4f
#define CALENDAR_ENTRY_BORDER                 4.0f

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarEntryView (PrivateAPI)

- (CGRect)calendarDateViewRect:(CGRect)_cotentFrame;
- (void)initializeDateFormatters;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarEntryView

@synthesize dateView, backgroundView, dayOfWeekView, photoView, dayFormatter, dayOfWeekFormatter;

#pragma mark -
#pragma mark CalendarEntryView PrivatAPI

- (CGRect)calendarDateViewRect:(CGRect)_cotentFrame {
    CGSize dateViewSize = CGSizeMake(CALENDAR_ENTRY_DATE_SCALE_FACTOR * _cotentFrame.size.width, CALENDAR_ENTRY_DATE_SCALE_FACTOR * _cotentFrame.size.width);
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
        CGRect contentFrame = CGRectMake(CALENDAR_ENTRY_BORDER, CALENDAR_ENTRY_BORDER, self.frame.size.width - CALENDAR_ENTRY_BORDER, self.frame.size.height - CALENDAR_ENTRY_BORDER);
        UIView* contentView = [[UIView alloc] initWithFrame:contentFrame];
        contentView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
        CGRect dateRect = [self calendarDateViewRect:contentFrame];
        NSString* date = [self.dayFormatter stringFromDate:_date];
        self.dateView = [CalandarDateView withFrame:dateRect andDate:date];
        self.backgroundView = [CalendarDayBackgroundView withFrame:dateRect];
        NSString* dayOfWeek = [self.dayOfWeekFormatter stringFromDate:_date];
        self.dayOfWeekView = [CalendarDayOfWeekView withFrame:dateRect andDayOfWeek:dayOfWeek];
        [self addSubview:contentView];
        if (_photo) {   
            self.photoView = [[UIImageView alloc] initWithImage:_photo];
            [contentView addSubview:self.photoView];
        }
        [contentView addSubview:self.backgroundView];
        [contentView addSubview:self.dateView];
    }
    return self;    
}

@end