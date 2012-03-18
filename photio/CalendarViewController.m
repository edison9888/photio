//
//  CalendarViewController.m
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarViewController.h"
#import "ViewGeneral.h"
#import "CalendarDayView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (PrivateAPI)

- (NSMutableArray*)setDayViews;
- (void)setDateFormatters;
- (NSDate*)startDay;
- (NSDate*)startWeek:(NSInteger)_weekOffset;
- (CGRect)dayViewRect:(NSInteger)_weeks;
- (NSInteger)rowsInView;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarViewController

@synthesize containerView, dragGridView, calendar, firstMonth, lastMonth, year,
            yearFormatter, dayFormatter, monthFormatter;

#pragma mark -
#pragma mark CalendarViewController PrivateAPI

- (NSMutableArray*)setDayViews {
    NSDate* startDate = [self startDay];
    NSInteger totalRowsInView = [self rowsInView];
    NSMutableArray* dayViews = [NSMutableArray arrayWithCapacity:CALENDAR_VIEW_COUNT * totalRowsInView];
    NSInteger currentDay = 0;
    CGRect calendarDateViewRect = [self dayViewRect:totalRowsInView];
    for (int i = 0; i < (CALENDAR_VIEW_COUNT * totalRowsInView); i++) {
        NSMutableArray* daysInRowViews = [NSMutableArray arrayWithCapacity:CALENDAR_DAYS_IN_ROW];
        for (int j = 0; j < CALENDAR_DAYS_IN_ROW; j++) {
            NSDateComponents* dateInterval = [[NSDateComponents alloc] init];
            [dateInterval setDay:-currentDay];
            NSDate* previoustDay = [self.calendar dateByAddingComponents:dateInterval toDate:startDate options:0];
            NSDateComponents* nextDayComponents = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:previoustDay];
            NSDate* calendarDate = [self.calendar dateFromComponents:nextDayComponents];
            NSString* day = [self.dayFormatter stringFromDate:calendarDate];
            if (currentDay == 0) {
                self.year = [self.yearFormatter stringFromDate:calendarDate];
                self.firstMonth = [self.monthFormatter stringFromDate:calendarDate];
            }
            if (currentDay == totalRowsInView * CALENDAR_DAYS_IN_ROW) {
                self.lastMonth = [self.monthFormatter stringFromDate:calendarDate];            
            }
            [daysInRowViews addObject:[CalendarDayView withFrame:calendarDateViewRect date:day andPhoto:nil]];
            currentDay++;
        }
        [dayViews addObject:daysInRowViews];
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


- (NSDate*)startDay {
    NSDateComponents* comps = [self.calendar components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:[NSDate date]];
    return [self.calendar dateFromComponents:comps];
}

- (NSDate*)startWeek:(NSInteger)_weekOffset {
    NSDateComponents* comps = [self.calendar components:NSWeekdayCalendarUnit fromDate:[NSDate date]];
    NSInteger daysToEndOfWeek = (_weekOffset + 1) * CALENDAR_DAYS_IN_ROW - [comps weekday];
    NSDateComponents* endOfWeekDate = [[NSDateComponents alloc] init];
    [endOfWeekDate setDay:daysToEndOfWeek];
    return [self.calendar dateByAddingComponents:endOfWeekDate toDate:[NSDate date] options:0];
}

-(CGRect)dayViewRect:(NSInteger)_rows {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    return CGRectMake(0.0, 0.0, bounds.size.width / CALENDAR_DAYS_IN_ROW, bounds.size.height / _rows);
}

- (NSInteger)rowsInView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    NSInteger viewWidth = bounds.size.width / CALENDAR_DAYS_IN_ROW;
    NSInteger rows = bounds.size.height / (DAY_VIEW_ASPECT_RATIO * viewWidth);
    return rows;
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
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        [self setDateFormatters];
        self.dragGridView = [DragGridView withFrame:self.view.frame delegate:self rows:[self setDayViews] andRelativeView:self.containerView];
        self.dragGridView.userInteractionEnabled = YES;
        [self.view addSubview:self.dragGridView];
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
#pragma mark DragGridViewDelegate

- (NSArray*)needRows {
    return [[NSArray alloc] init];
}

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] dragCalendarToCamera:_drag];
}

- (void)didReleaseRight:(CGPoint)_location {
}

- (void)didReleaseLeft:(CGPoint)_location {
    [[ViewGeneral instance] releaseCalendarToCamera];
}

- (void)didSwipeRight:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionCalendarToCamera];
}

- (void)didReachMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didReachMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionCalendarToCamera];    
}

@end
