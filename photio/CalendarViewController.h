//
//  CalendarViewController.h
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragGridView.h"

@class DragGridView;

@interface CalendarViewController : UIViewController <DragGridViewDelegate> {
    __weak UIView*                  containerView;
    DragGridView*                   dragGridView;
    NSCalendar*                     calendar;
    NSString*                       firstMonth;
    NSString*                       lastMonth;
    NSString*                       year;
    NSDateFormatter*                dayFormatter;
    NSDateFormatter*                yearFormatter;
    NSDateFormatter*                monthFormatter;
}

@property (nonatomic, weak)   UIView*                           containerView;
@property (nonatomic, retain) DragGridView*                     dragGridView;
@property (nonatomic, retain) NSCalendar*                       calendar;
@property (nonatomic, retain) NSString*                         firstMonth;
@property (nonatomic, retain) NSString*                         lastMonth;
@property (nonatomic, retain) NSString*                         year;
@property (nonatomic, retain) NSDateFormatter*                  dayFormatter;
@property (nonatomic, retain) NSDateFormatter*                  yearFormatter;
@property (nonatomic, retain) NSDateFormatter*                  monthFormatter;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
