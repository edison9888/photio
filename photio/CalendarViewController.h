//
//  CalendarViewController.h
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragGridView.h"

@interface CalendarViewController : UIViewController <DragGridViewDelegate> {
}

@property(nonatomic, weak)   UIView*                            containerView;
@property(nonatomic, strong) NSMutableArray*                    thumbnails;
@property(nonatomic, strong) DragGridView*                      dragGridView;
@property(nonatomic, strong) NSCalendar*                        calendar;
@property(nonatomic, strong) NSString*                          firstMonth;
@property(nonatomic, strong) NSString*                          lastMonth;
@property(nonatomic, strong) NSString*                          year;
@property(nonatomic, strong) NSDateFormatter*                   dayFormatter;
@property(nonatomic, strong) NSDateFormatter*                   dayOfWeekFormatter;
@property(nonatomic, strong) NSDateFormatter*                   yearFormatter;
@property(nonatomic, strong) NSDateFormatter*                   monthFormatter;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
