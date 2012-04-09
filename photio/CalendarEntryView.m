//
//  CalendarEntryView.m
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarEntryView.h"
#import "CalandarDateView.h"
#import "ViewGeneral.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarEntryView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarEntryView

@synthesize dateView, photoView;

#pragma mark -
#pragma mark CalendarEntryView PrivatAPI

#pragma mark -
#pragma mark CalendarEntryView

+ (id)withFrame:(CGRect)_frame date:(NSString*)_date andPhoto:(UIImage*)_photo {
    return [[CalendarEntryView alloc] initWithFrame:_frame date:_date andPhoto:_photo];
}

- (id)initWithFrame:(CGRect)_frame date:(NSString*)_date andPhoto:(UIImage*)_photo {
    if ((self = [super initWithFrame:_frame])) {
        self.backgroundColor = [UIColor blackColor];
        CGRect contentFrame = CGRectMake(CALENDAR_ENTRY_BORDER, CALENDAR_ENTRY_BORDER, self.frame.size.width - CALENDAR_ENTRY_BORDER, self.frame.size.height - CALENDAR_ENTRY_BORDER);
        UIView* contentView = [[UIView alloc] initWithFrame:contentFrame];
        contentView.backgroundColor = [UIColor whiteColor];
        self.dateView = [CalandarDateView withFrame:[ViewGeneral calendarDateViewRect:contentFrame] andDate:_date];
        [self addSubview:contentView];
        if (_photo) {   
            self.photoView = [[UIImageView alloc] initWithImage:_photo];
            [contentView addSubview:self.photoView];
            [self.photoView addSubview:self.dateView];
        } else {
            [contentView addSubview:self.dateView];
        }
    }
    return self;    
}

@end
