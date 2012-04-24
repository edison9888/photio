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

#define CALENDAR_DAYS_IN_ROW                3
#define CALENDAR_VIEW_COUNT                 10
#define CALENDAR_MONTH_YEAR_VIEW_HEIGHT     25.0

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (PrivateAPI)

- (NSMutableArray*)addViewsBetweenDates:(NSDate*)_startdate and:(NSDate*)_endDate;
- (NSMutableArray*)addViewRows;
- (NSMutableArray*)addDayViewsForRow;
- (NSDate*)incrementDate:(NSDate*)_date by:(NSInteger)_interval;
- (void)initializeDateFormatters;
- (void)initializeCalendarRowsInView;
- (void)initializeCalendarEntryViewRect;
- (void)initializeOldestDate;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (CoreData)

- (NSMutableArray*)fetchCapturesBetweenDates:(NSDate*)_startdate and:(NSDate*)_endDate;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarViewController

@synthesize containerView, monthAndYearView, oldestDate, julianDayFormatter, dragGridView, calendar, captures, 
            viewCount, daysInRow, totalDays, rowsInView, calendarEntryViewRect;

#pragma mark -
#pragma mark CalendarViewController PrivateAPI

- (NSMutableArray*)addViewsBetweenDates:(NSDate*)_startdate and:(NSDate*)_endDate {
    self.captures = [self fetchCapturesBetweenDates:_startdate and:_endDate];
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
//        if (self.captures < [self.thumbnails count]) {
//            Capture* capture = [self.thumbnails objectAtIndex:self.totalDays];
//            thumbnail = capture.thumbnail;
//        }
        [rowViews addObject:[CalendarEntryView withFrame:self.calendarEntryViewRect date:self.oldestDate andPhoto:thumbnail]];
        self.oldestDate = [self incrementDate:self.oldestDate by:-1];
        self.totalDays++;
    }
    return rowViews;
}

- (void)initializeDateFormatters {
    self.julianDayFormatter = [[NSDateFormatter alloc] init];
    [self.julianDayFormatter setDateFormat:@"g"];
}

- (NSDate*)incrementDate:(NSDate*)_date by:(NSInteger)_interval {
    NSDateComponents* dateInterval = [[NSDateComponents alloc] init];
    [dateInterval setDay:_interval];
    return [self.calendar dateByAddingComponents:dateInterval toDate:_date options:0];
}


- (void)initializeOldestDate {
    NSDateComponents* comps = [self.calendar components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:[NSDate date]];
    self.oldestDate = [self.calendar dateFromComponents:comps];
}

- (void)initializeRowsInView {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    NSInteger viewWidth = bounds.size.width / self.daysInRow;
    self.rowsInView = bounds.size.height / viewWidth;
}

- (void)initializeCalendarEntryViewRect {
    CGFloat width = [[UIScreen mainScreen] bounds].size.width / self.daysInRow;
    self.calendarEntryViewRect =  CGRectMake(0.0, 0.0, width, width);
}

#pragma mark -
#pragma mark CalendarViewController CoreData

- (NSMutableArray*)fetchCapturesBetweenDates:(NSDate*)_startdate and:(NSDate*)_endDate {

    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    fetchRequest.resultType = NSDictionaryResultType;
    
    NSEntityDescription* entity = [NSEntityDescription entityForName:@"Capture" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor* sort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];

    NSError* error = nil;
	NSMutableArray* fetchResults = [[[ViewGeneral instance].managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	if (fetchResults == nil) {
		[[[UIAlertView alloc] initWithTitle:@"Error Retrieving Photos" message:@"Your photos were not retrieved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}
    return fetchResults;
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
        self.daysInRow = CALENDAR_DAYS_IN_ROW;
        self.viewCount = CALENDAR_VIEW_COUNT;
        self.totalDays = 0;
        [self initializeDateFormatters];
        [self initializeRowsInView];
        [self initializeCalendarEntryViewRect];
        [self initializeOldestDate];
    }
    return self;
}

- (CGRect)calendarImageThumbnailRect {
    return self.calendarEntryViewRect;
}

- (NSString*)julianDay:(NSDate*)_date {
    return [self.julianDayFormatter stringFromDate:_date];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect yearMonthRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, CALENDAR_MONTH_YEAR_VIEW_HEIGHT);
    NSDate* startDate = [NSDate date];
    NSDate* endDate = [self incrementDate:[NSDate date] by:-(self.rowsInView*self.daysInRow)];
    self.monthAndYearView = [CalendarMonthAndYearView withFrame:yearMonthRect delegate:self startDate:startDate andEndDate:endDate];
    [self.view addSubview:self.monthAndYearView];
    CGRect dragGridRect = CGRectMake(0.0, CALENDAR_MONTH_YEAR_VIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - CALENDAR_MONTH_YEAR_VIEW_HEIGHT);
    self.dragGridView = [DragGridView withFrame:dragGridRect delegate:self rows:[self addViewsBetweenDates:startDate and:endDate] andRelativeView:self.containerView];
    self.dragGridView.rowBuffer = self.rowsInView * self.viewCount;
    [self.view addSubview:self.dragGridView];
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
    return [self addViewsBetweenDates:[self incrementDate:[NSDate date] by:-_row*self.daysInRow] and:[self incrementDate:[NSDate date] by:-self.daysInRow*(_row + self.rowsInView)]];
}

- (void)removedBottomRow:(NSArray*)_row {
    self.totalDays -= [_row count];
    CalendarEntryView* entryView = [_row objectAtIndex:0];
    self.oldestDate = entryView.date;
}

- (void)topRowChanged:(NSInteger)_row {
    [self.monthAndYearView updateStartDate:[self incrementDate:[NSDate date] by:-_row*self.daysInRow] andEndDate:[self incrementDate:[NSDate date] by:-self.daysInRow*(_row + self.rowsInView)]];
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
