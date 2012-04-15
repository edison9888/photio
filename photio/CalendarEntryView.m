//
//  CalendarEntryView.m
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarEntryView.h"
#import "CalandarDateView.h"
#import "CalendarDayBackgroundView.h"
#import "ViewGeneral.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarEntryView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarEntryView

@synthesize dateView, backgroundView, photoView;

#pragma mark -
#pragma mark CalendarEntryView PrivatAPI

#pragma mark -
#pragma mark CalendarEntryView

+ (id)withFrame:(CGRect)_frame date:(NSString*)_date dayOfWeek:(NSString*)_dayOfWeek andPhoto:(UIImage*)_photo {
    return [[CalendarEntryView alloc] initWithFrame:_frame date:_date dayOfWeek:_dayOfWeek andPhoto:_photo];
}

- (id)initWithFrame:(CGRect)_frame date:(NSString*)_date dayOfWeek:(NSString*)_dayOfWeek andPhoto:(UIImage*)_photo {
    if ((self = [super initWithFrame:_frame])) {
        self.backgroundColor = [UIColor blackColor];
        CGRect contentFrame = CGRectMake(CALENDAR_ENTRY_BORDER, CALENDAR_ENTRY_BORDER, self.frame.size.width - CALENDAR_ENTRY_BORDER, self.frame.size.height - CALENDAR_ENTRY_BORDER);
        UIView* contentView = [[UIView alloc] initWithFrame:contentFrame];
        contentView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];
        CGRect dateRect = [ViewGeneral calendarDateViewRect:contentFrame];
        self.dateView = [CalandarDateView withFrame:dateRect andDate:_date];
        self.backgroundView = [CalendarDayBackgroundView withFrame:dateRect];
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
