//
//  CalendarDayOfWeekView.h
//  photio
//
//  Created by Troy Stribling on 4/15/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarDayOfWeekView : UITextField

+ (id)withFrame:(CGRect)_frame andDayOfWeek:(NSString*)_dayOfWeek;
- (id)initWithFrame:(CGRect)_frame andDayOfWeek:(NSString*)_dayOfWeek;

@end
