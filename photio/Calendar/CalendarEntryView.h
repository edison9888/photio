//
//  CalendarEntryView.h
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalandarDateView;
@class CalendarDayBackgroundView;
@class CalendarDayOfWeekView;

@interface CalendarEntryView : UIView 

@property(nonatomic, strong) CalandarDateView*              dateView; 
@property(nonatomic, strong) CalendarDayBackgroundView*     backgroundView;
@property(nonatomic, strong) CalendarDayOfWeekView*         dayOfWeekView;
@property(nonatomic, strong) UIImageView*                   photoView;
@property(nonatomic, strong) NSDateFormatter*               dayFormatter;
@property(nonatomic, strong) NSDateFormatter*               dayOfWeekFormatter;

+ (id)withFrame:(CGRect)_frame date:(NSDate*)_date andPhoto:(UIImage*)_photo;
- (id)initWithFrame:(CGRect)_frame date:(NSDate*)_date andPhoto:(UIImage*)_photo;

@end
