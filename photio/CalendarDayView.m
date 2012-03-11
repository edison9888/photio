//
//  CalendarDayView.m
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarDayView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarDayView (PrivateAPI)

- (CGRect)dateViewRect:(CGRect)_cotentFrame;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarDayView

@synthesize dayView, photoView;

#pragma mark -
#pragma mark CalendarDayView PrivatAPI

- (CGRect)dateViewRect:(CGRect)_cotentFrame {
    CGSize dateViewSize = CGSizeMake(DAY_VIEW_DATE_X_OFFSET_SCALE * self.frame.size.width, DAY_VIEW_DATE_HEIGHT);
    CGPoint dateViewOffset = CGPointMake(self.frame.size.width - dateViewSize.width - DAY_VIEW_DATE_X_OFFSET, DAY_VIEW_DATE_Y_OFFSET);
    return CGRectMake(dateViewOffset.x, dateViewOffset.y, dateViewSize.width, dateViewSize.height);
}

#pragma mark -
#pragma mark CalendarDayView

+ (id)withFrame:(CGRect)_frame date:(NSString*)_date andPhoto:(UIImage*)_photo {
    return [[CalendarDayView alloc] initWithFrame:_frame date:_date andPhoto:_photo];
}

- (id)initWithFrame:(CGRect)_frame date:(NSString*)_date andPhoto:(UIImage*)_photo {
    if ((self = [super initWithFrame:_frame])) {
        self.backgroundColor = [UIColor blackColor];
        CGRect contentFrame = CGRectMake(DAY_VIEW_BORDER, DAY_VIEW_BORDER, self.frame.size.width - DAY_VIEW_BORDER, self.frame.size.height - DAY_VIEW_BORDER);
        UIView* contentView = [[UIView alloc] initWithFrame:contentFrame];
        contentView.backgroundColor = [UIColor whiteColor];
        CGRect dateFrame = [self dateViewRect:contentFrame];
        [self addSubview:contentView];
        self.dayView = [[UITextField alloc] initWithFrame:dateFrame];
        self.dayView.textAlignment = UITextAlignmentRight;
        self.dayView.text = _date;
        self.dayView.font = [self.dayView.font fontWithSize:DAY_VIEW_DATE_IPHONE_FONT_SIZE];
        self.dayView.enabled = NO;
        if (_photo) {   
            self.photoView = [[UIImageView alloc] initWithImage:_photo];
            [contentView addSubview:self.photoView];
            [self.photoView addSubview:self.dayView];
        } else {
            [contentView addSubview:self.dayView];
        }
    }
    return self;    
}

@end
