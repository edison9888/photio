//
//  CalendarViewController.m
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarViewController.h"
#import "ViewGeneral.h"
#import "CalendarEntryView.h"
#import "Capture.h"
#import "ImageThumbnail.h"
#import "CaptureManager.h"
#import "NSArray+Extensions.h"

#define CALENDAR_VIEW_COUNT                 5
#define CALENDAR_MONTH_YEAR_VIEW_HEIGHT     25.0

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (PrivateAPI)

- (NSMutableArray*)addViewsBetweenDates:(NSDate*)_startdate and:(NSDate*)_endDate;
- (NSMutableArray*)addViewRows;
- (NSMutableArray*)addDayViewsForRow;
- (NSDate*)incrementDate:(NSDate*)_date by:(NSInteger)_interval;
- (void)initializeCalendarRowsInView;
- (void)initializeOldestDate;
- (void)addCaptureObserver;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (CoreData)

- (void)updateLatestCapture;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarViewController

@synthesize containerView, monthAndYearView, oldestDate, dragGridView, calendar, captures, 
            viewCount, daysInRow, totalDays, captureIndex, rowsInView, calendarEntryViewRect;

#pragma mark -
#pragma mark CalendarViewController PrivateAPI

- (NSMutableArray*)addViewsBetweenDates:(NSDate*)_startdate and:(NSDate*)_endDate {
    self.captures = [[CaptureManager fetchCaptureForEachDayBetweenDates:_startdate and:_endDate] mutableCopy];
    self.captureIndex = 0;
    NSMutableArray* initialDayViews = [NSMutableArray arrayWithCapacity:self.viewCount * self.rowsInView];
    for (int i = 0; i < self.viewCount; i++) {
        [initialDayViews addObjectsFromArray:[self addViewRows]];
    }
    self.captures = nil;
    return initialDayViews;
}

- (NSMutableArray*)addViewRows {
    NSMutableArray* rowsOfViews = [NSMutableArray arrayWithCapacity:self.rowsInView];
    for (int i = 0; i < self.rowsInView; i++) {
        [rowsOfViews addObject:[self addDayViewsForRow]];
    }
    return rowsOfViews;
}

- (NSMutableArray*)addDayViewsForRow {
    NSMutableArray* rowViews = [NSMutableArray arrayWithCapacity:self.daysInRow];
    for (int j = 0; j < self.daysInRow; j++) {
        UIImage* thumbnail = nil;
        NSString* dayIdentifier;
        NSString* oldestDayIdentifier = [CaptureManager dayIdentifier:self.oldestDate];
        if ([self.captures count] > 0) {            
            Capture* capture= [self.captures objectAtIndex:self.captureIndex];
            NSString* captureDayIdentifier = capture.dayIdentifier;
            if ([captureDayIdentifier isEqualToString:oldestDayIdentifier]) {
                dayIdentifier = captureDayIdentifier;
                thumbnail = capture.thumbnail.image;
                if (self.captureIndex < [self.captures count] - 1) {
                    self.captureIndex++;
                }
            }
        }
        [rowViews addObject:[CalendarEntryView withFrame:self.calendarEntryViewRect date:self.oldestDate dayIdentifier:dayIdentifier andPhoto:thumbnail]];
        self.oldestDate = [self incrementDate:self.oldestDate by:-1];
        self.totalDays++;
    }
    return rowViews;
}

- (NSDate*)incrementDate:(NSDate*)_date by:(NSInteger)_interval {
    NSDateComponents* dateInterval = [[NSDateComponents alloc] init];
    [dateInterval setDay:_interval];
    return [self.calendar dateByAddingComponents:dateInterval toDate:_date options:0];
}


- (void)initializeOldestDate {
    self.oldestDate = [self floorDate:[NSDate date]];
}

- (void)initializeRowsInView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    NSInteger viewWidth = bounds.size.width / self.daysInRow;
    self.rowsInView = bounds.size.height / viewWidth;
}

#pragma mark -
#pragma mark CalendarViewController

+ (id)inView:(UIView*)_containerView {
    return [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil inView:_containerView];;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        self.containerView = _containerView;
        self.daysInRow = THUMBNAILS_IN_ROW;
        self.viewCount = CALENDAR_VIEW_COUNT;
        self.totalDays = 0;
        [self initializeRowsInView];
        self.calendarEntryViewRect = [ViewGeneral imageThumbnailRect];
    }
    return self;
}

- (void)loadCalendarViews {
    if (self.dragGridView) {
        [self.dragGridView removeFromSuperview];
    }
    if (self.monthAndYearView) {
        [self.monthAndYearView removeFromSuperview];
    }
    [self initializeOldestDate];
    CGRect yearMonthRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, CALENDAR_MONTH_YEAR_VIEW_HEIGHT);
    NSDate* endDate = [NSDate date];
    NSDate* gridStartDate = [self incrementDate:[NSDate date] by:-(self.rowsInView*self.daysInRow*self.viewCount)];
    NSDate* monthAndYearViewStartDate = [self incrementDate:[NSDate date] by:-(self.rowsInView*self.daysInRow)];
    self.monthAndYearView = [CalendarMonthAndYearView withFrame:yearMonthRect delegate:self startDate:monthAndYearViewStartDate andEndDate:endDate];
    [self.view addSubview:self.monthAndYearView];
    CGRect dragGridRect = CGRectMake(0.0, CALENDAR_MONTH_YEAR_VIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - CALENDAR_MONTH_YEAR_VIEW_HEIGHT);
    self.dragGridView = [DragGridView withFrame:dragGridRect delegate:self rows:[self addViewsBetweenDates:gridStartDate and:endDate] andRelativeView:self.containerView];
    self.dragGridView.rowBuffer = self.rowsInView * self.viewCount;
    [self.view addSubview:self.dragGridView];
}

- (void)updateEntryWithDate:(NSDate*)_date {
    Capture* capture = [CaptureManager fetchCaptureWithDayIdentifierCreatedAt:_date];
    CalendarEntryView* firstEntryView = [[self.dragGridView rowViewAtIndex:0] objectAtIndex:0];
    NSTimeInterval deltaDate = [[self floorDate:firstEntryView.date] timeIntervalSinceDate:[self floorDate:_date]] / (3600.0 * 24.0);
    NSInteger entryRow = deltaDate / self.rowsInView;
    NSInteger entryColumn = (NSInteger)deltaDate - entryRow * self.rowsInView;
    CalendarEntryView* entryView = [[self.dragGridView rowViewAtIndex:entryRow] objectAtIndex:entryColumn];
    if (capture) {
        entryView.photoView.image = capture.thumbnail.image;
        entryView.dayIdentifier = capture.dayIdentifier;
        entryView.date = capture.createdAt;
    } else {
        entryView.photoView.image = nil;
        entryView.dayIdentifier = nil;
    }
}

- (NSDate*)floorDate:(NSDate*)_date {
    NSDateComponents* comps = [self.calendar components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:_date];
    return [self.calendar dateFromComponents:comps];
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

- (NSArray*)needBottomRows:(NSInteger)_row {
    return [self addViewsBetweenDates:[self incrementDate:[NSDate date] by:-_row*self.daysInRow] and:[self incrementDate:[NSDate date] by:-self.daysInRow*(_row + self.viewCount*self.rowsInView)]];
}

- (void)removedBottomRow:(NSArray*)_row {
    self.totalDays -= [_row count];
    CalendarEntryView* entryView = [_row objectAtIndex:0];
    self.oldestDate = entryView.date;
}

- (void)topRowChanged:(NSInteger)_row {
    [self.monthAndYearView updateStartDate:[self incrementDate:[NSDate date] by:-self.daysInRow*(_row + self.rowsInView)] andEndDate:[self incrementDate:[NSDate date] by:-_row*self.daysInRow]];
}

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] dragCalendar:_drag];
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] dragCalendar:_drag];
}

- (void)didReleaseRight:(CGPoint)_location {
    [[ViewGeneral instance] releaseCalendar];
}

- (void)didReleaseLeft:(CGPoint)_location {
    [[ViewGeneral instance] releaseCalendar];
}

- (void)didSwipeRight:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionCalendarToCamera];
}

- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] releaseCalendar];
}

- (void)didReachMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionCalendarToCamera];    
}

- (void)didReachMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] releaseCalendar];
}

#pragma mark -
#pragma mark CalendarMonthAndYearViewDelegate

- (void)didTouchCalendarMonthAndYearView {
    [self.dragGridView scrollToTop];
}


@end
