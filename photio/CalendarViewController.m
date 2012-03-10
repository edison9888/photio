//
//  CalendarViewController.m
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarViewController.h"
#import "ViewGeneral.h"
#import "DragGridView.h"
#import "CalendarDayView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (PrivateAPI)

- (NSArray*)setDayViews;
- (void)setDateFormatters;
- (NSDate*)endOfWeek;
- (CGRect)dayViewRect:(NSInteger)_weeks;
- (NSArray*)dayView:(CGRect)_frame withDate:(NSString*)_date andPhoto:(UIImage*)_photo;
- (NSInteger)weeksInView;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarViewController

@synthesize containerView, transitionGestureRecognizer, dragGridView, calendar, firstMonth, lastMonth, year,
            yearFormatter, dayFormatter, monthFormatter;

#pragma mark -
#pragma mark CalendarViewController PrivateAPI

- (NSArray*)setDayViews {
    NSDate* endOfWeeKDate = [self endOfWeek];
    NSInteger weeks = [self weeksInView];
    NSMutableArray* dayViews = [NSMutableArray arrayWithCapacity:2 * weeks];
    NSInteger currentDay = 0;
    CGRect calendarDateViewRect = [self dayViewRect:weeks];
    for (int i = 0; i < 2 * weeks; i++) {
        NSMutableArray* daysOfWeekViews = [NSMutableArray arrayWithCapacity:7];
        for (int j = 0; j < CALENDAR_DAYS_IN_WEEK; j++) {
            NSDateComponents* dateInterval = [[NSDateComponents alloc] init];
            [dateInterval setDay:-i];
            NSDate* previoustDay = [self.calendar dateByAddingComponents:dateInterval toDate:endOfWeeKDate options:0];
            NSDateComponents* nextDayComponents = 
                [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:previoustDay];
            NSDate* calendarDate = [self.calendar dateFromComponents:nextDayComponents];
            NSString* day = [self.dayFormatter stringFromDate:calendarDate];
            if (currentDay == 0) {
                self.year = [self.yearFormatter stringFromDate:calendarDate];
                self.firstMonth = [self.monthFormatter stringFromDate:calendarDate];
            }
            if (currentDay == weeks * CALENDAR_DAYS_IN_WEEK) {
                self.lastMonth = [self.monthFormatter stringFromDate:calendarDate];            
            }
            [daysOfWeekViews addObject:[self dayView:calendarDateViewRect withDate:day andPhoto:nil]];
            currentDay++;
        }
        [dayViews addObject:daysOfWeekViews];
    }
    return dayViews;
}

- (void)setDateFormatters {
    self.dayFormatter = [[NSDateFormatter alloc] init];
    [self.dayFormatter setDateFormat:@"d"];
    self.yearFormatter = [[NSDateFormatter alloc] init];
    [self.yearFormatter setDateFormat:@"yyyy"];
    self.monthFormatter = [[NSDateFormatter alloc] init];
    [self.monthFormatter setDateFormat:@"MMMM"];
}


- (NSDate*)endOfWeek {
    NSDateComponents* comps = [self.calendar components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger daysToEndOfWeek = 7 - [comps weekday];
    NSDateComponents* endOfWeekDate = [[NSDateComponents alloc] init];
    [endOfWeekDate setDay:daysToEndOfWeek];
    return [self.calendar dateByAddingComponents:endOfWeekDate toDate:[NSDate date] options:0];
}

-(CGRect)dayViewRect:(NSInteger)_weeks {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    return CGRectMake(0.0, 0.0, bounds.size.width / CALENDAR_DAYS_IN_WEEK, bounds.size.height / _weeks);
}

-(NSArray*)dayView:(CGRect)_frame withDate:(NSString*)_date andPhoto:(UIImage*)_photo {
    NSMutableArray* copies = [NSMutableArray arrayWithCapacity:3];
    for (int i = 0; i < CALENDAR_VIEW_COPIES; i++) {
        [copies addObject:[CalendarDayView withFrame:_frame date:_date andPhoto:_photo]];
    }
    return copies;
}

- (NSInteger)weeksInView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    NSInteger viewWidth = bounds.size.width / CALENDAR_DAYS_IN_WEEK;
    NSInteger weeks = bounds.size.height / (DAY_VIEW_ASPECT_RATIO * viewWidth);
    return weeks;
}

#pragma mark -
#pragma mark CalendarViewController

+ (id)inView:(UIView*)_containerView {
    return [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil inView:_containerView];;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self.view relativeToView:self.containerView];
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [self setDateFormatters];
        [self setDayViews];
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


#pragma mark -
#pragma mark TransitionGestureRecognizerDelegate

- (void)didDragUp:(CGPoint)_drag {
}

- (void)didDragDown:(CGPoint)_drag {
    [[ViewGeneral instance] dragCalendarToCamera:_drag];
}

- (void)didReleaseUp {
}

- (void)didReleaseDown {
    [[ViewGeneral instance] releaseCalendarToCamera];
}

- (void)didSwipeUp {
}

- (void)didSwipeDown {
    [[ViewGeneral instance] transitionCalendarToCamera];
}

@end
