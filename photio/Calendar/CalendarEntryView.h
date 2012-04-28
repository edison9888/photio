//
//  CalendarEntryView.h
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EntriesViewController.h"

@class CalendarDayView;
@class CalendarDayBackgroundView;
@class CalendarDayOfWeekView;

@interface CalendarEntryView : UIView <EntriesViewControllerDelegate>

@property(nonatomic, strong) CalendarDayView*               dayView; 
@property(nonatomic, strong) CalendarDayBackgroundView*     backgroundView;
@property(nonatomic, strong) CalendarDayOfWeekView*         dayOfWeekView;
@property(nonatomic, strong) UIImageView*                   photoView;
@property(nonatomic, strong) NSDateFormatter*               dayFormatter;
@property(nonatomic, strong) NSDateFormatter*               dayOfWeekFormatter;
@property(nonatomic, strong) NSDate*                        date;
@property(nonatomic, strong) NSString*                      dayIdentifier;

+ (id)withFrame:(CGRect)_frame date:(NSDate*)_date dayIdentifier:(NSString*)_dayIdentifier andPhoto:(UIImage*)_photo;
- (id)initWithFrame:(CGRect)_frame date:(NSDate*)_date dayIdentifier:(NSString*)_dayIdentifier andPhoto:(UIImage*)_photo;

@end
