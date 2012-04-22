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
#import "CalendarMonthAndYearView.h"
#import "Capture.h"

#define CALENDAR_DAYS_IN_ROW                3
#define CALENDAR_VIEW_COUNT                 2
#define CALENDAR_MONTH_YEAR_VIEW_HEIGHT     30.0

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (PrivateAPI)

- (NSMutableArray*)addViews;
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

- (NSMutableArray*)fetchThumbnails;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarViewController

@synthesize containerView, monthAndYearView, thumbnails, oldestDate, dragGridView, calendar, 
            viewCount, daysInRow, totalDays, rowsInView, topRow, calendarEntryViewRect;

#pragma mark -
#pragma mark CalendarViewController PrivateAPI

- (NSMutableArray*)addViews {
    NSMutableArray* initialDayViews = [NSMutableArray arrayWithCapacity:self.viewCount * self.rowsInView];
    for (int i = 0; i < self.viewCount; i++) {
        [initialDayViews addObjectsFromArray:[self addViewRows]];
    }
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
        if (self.totalDays < [self.thumbnails count]) {
            Capture* capture = [self.thumbnails objectAtIndex:self.totalDays];
            thumbnail = capture.thumbnail;
        }
        [rowViews addObject:[CalendarEntryView withFrame:self.calendarEntryViewRect date:self.oldestDate andPhoto:thumbnail]];
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

- (NSMutableArray*)fetchThumbnails {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Capture" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO];
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
        [self initializeRowsInView];
        [self initializeCalendarEntryViewRect];
        [self initializeOldestDate];
    }
    return self;
}

- (CGRect)calendarImageThumbnailRect {
    return self.calendarEntryViewRect;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect yearMonthRect = CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height);
    self.monthAndYearView = [CalendarMonthAndYearView withFrame:yearMonthRect startDate:[NSDate date] andEndDate:[self incrementDate:[NSDate date] by:self.totalDays]];
    [self.view addSubview:self.monthAndYearView];
    self.thumbnails = [self fetchThumbnails];
    CGRect dragGridRect = CGRectMake(0.0, CALENDAR_MONTH_YEAR_VIEW_HEIGHT, self.view.frame.size.width, self.view.frame.size.height - CALENDAR_MONTH_YEAR_VIEW_HEIGHT);
    self.dragGridView = [DragGridView withFrame:dragGridRect delegate:self rows:[self addViews] andRelativeView:self.containerView];
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

- (NSArray*)needBottomRows {
    return [self addViews];
}

- (void)removedBottomRow:(NSArray*)_row {
    self.totalDays -= [_row count];
    CalendarEntryView* entryView = [_row objectAtIndex:0];
    self.oldestDate = entryView.date;
}

- (void)topRowChanged:(NSInteger)_row {
    self.topRow = _row;
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

@end
