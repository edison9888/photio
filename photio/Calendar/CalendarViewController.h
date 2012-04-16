//
//  CalendarViewController.h
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragGridView.h"

@interface CalendarViewController : UIViewController <DragGridViewDelegate, NSFetchedResultsControllerDelegate> {
}

@property(nonatomic, weak)   UIView*                    containerView;
@property(nonatomic, strong) NSMutableArray*            thumbnails;
@property(nonatomic, strong) NSDate*                    oldestDate;
@property(nonatomic, strong) DragGridView*              dragGridView;
@property(nonatomic, strong) NSCalendar*                calendar;
@property(nonatomic, strong) NSString*                  firstMonth;
@property(nonatomic, strong) NSString*                  lastMonth;
@property(nonatomic, strong) NSString*                  firstYear;
@property(nonatomic, strong) NSString*                  lastYear;
@property(nonatomic, strong) NSDateFormatter*           yearFormatter;
@property(nonatomic, strong) NSDateFormatter*           monthFormatter;
@property(nonatomic, assign) NSInteger                  viewCount;
@property(nonatomic, assign) NSInteger                  daysInRow;
@property(nonatomic, assign) NSInteger                  totalDays;
@property(nonatomic, assign) NSInteger                  rowsInView;
@property(nonatomic, assign) CGRect                     calendarEntryViewRect;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (CGRect)calendarImageThumbnailRect;

@end