//
//  CalendarEntryView.m
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarEntryView.h"
#import "CalandarDateView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarEntryView (PrivateAPI)

- (CGRect)dateViewRect:(CGRect)_cotentFrame;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarEntryView

@synthesize dateView, photoView;

#pragma mark -
#pragma mark CalendarEntryView PrivatAPI

- (CGRect)dateViewRect:(CGRect)_cotentFrame {
    CGSize dateViewSize = CGSizeMake(DAY_VIEW_DATE_X_OFFSET_SCALE * self.frame.size.width, DAY_VIEW_DATE_HEIGHT);
    CGPoint dateViewOffset = CGPointMake(self.frame.size.width - dateViewSize.width - DAY_VIEW_DATE_X_OFFSET, DAY_VIEW_DATE_Y_OFFSET);
    return CGRectMake(dateViewOffset.x, dateViewOffset.y, dateViewSize.width, dateViewSize.height);
}

#pragma mark -
#pragma mark CalendarEntryView

+ (id)withFrame:(CGRect)_frame date:(NSString*)_date andPhoto:(UIImage*)_photo {
    return [[CalendarEntryView alloc] initWithFrame:_frame date:_date andPhoto:_photo];
}

- (id)initWithFrame:(CGRect)_frame date:(NSString*)_date andPhoto:(UIImage*)_photo {
    if ((self = [super initWithFrame:_frame])) {
        self.backgroundColor = [UIColor blackColor];
        CGRect contentFrame = CGRectMake(DAY_VIEW_BORDER, DAY_VIEW_BORDER, self.frame.size.width - DAY_VIEW_BORDER, self.frame.size.height - DAY_VIEW_BORDER);
        UIView* contentView = [[UIView alloc] initWithFrame:contentFrame];
        contentView.backgroundColor = [UIColor whiteColor];
        self.dateView = [CalandarDateView withFrame:[self dateViewRect:contentFrame] andDate:_date];
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
