//
//  CalendarDayView.h
//  photio
//
//  Created by Troy Stribling on 4/8/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarDayView : UILabel

+ (id)withFrame:(CGRect)_frame andDay:(NSString*)_day;
- (id)initWithFrame:(CGRect)_frame andDay:(NSString*)_day;

@end
