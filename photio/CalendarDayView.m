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

- (CGRect)dayViewRect;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarDayView

@synthesize dayView, photoView;

#pragma mark -
#pragma mark CalendarDayView PrivatAPI

- (CGRect)dayViewRect {
    CGSize dayViewSize = CGSizeMake(DAY_VIEW_DATE_SCALE_FACTOR * self.frame.size.width, DAY_VIEW_DATE_SCALE_FACTOR * self.frame.size.height);
    CGPoint dayViewOffset = CGPointMake(self.frame.size.width - dayViewSize.width, 0.0);
    return CGRectMake(dayViewOffset.x, dayViewOffset.y, dayViewSize.width, dayViewSize.height);
}

#pragma mark -
#pragma mark CalendarDayView

+ (id)withFrame:(CGRect)_frame date:(NSString*)_date andPhoto:(UIImage*)_photo {
    return [[CalendarDayView alloc] initWithFrame:_frame date:_date andPhoto:_photo];
}

- (id)initWithFrame:(CGRect)_frame date:(NSString*)_date andPhoto:(UIImage*)_photo {
    if ((self = [super initWithFrame:_frame])) {
        CGRect dateFrame = [self dayViewRect];
        self.dayView = [[UITextField alloc] initWithFrame:dateFrame];
        self.dayView.text = _date;
        if (_photo) {   
            self.photoView = [[UIImageView alloc] initWithImage:_photo];
            [self addSubview:self.photoView];
            [self.photoView addSubview:self.dayView];
        } else {
            [self addSubview:self.dayView];
        }
    }
    return self;    
}

@end
