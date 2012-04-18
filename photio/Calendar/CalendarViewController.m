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

#define CALENDAR_DAYS_IN_ROW                            3
#define CALENDAR_VIEW_COUNT                             3

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (PrivateAPI)

- (NSMutableArray*)inititializeDayViews;
- (NSMutableArray*)addViewRows;
- (NSMutableArray*)addDayViewsForRow;
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

@synthesize containerView, thumbnails, oldestDate, dragGridView, calendar, firstDate, lastDate,
            yearFormatter, monthFormatter, viewCount, daysInRow, totalDays, rowsInView, calendarEntryViewRect;

#pragma mark -
#pragma mark CalendarViewController PrivateAPI

- (NSMutableArray*)inititializeDayViews {
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
        NSDateComponents* dateInterval = [[NSDateComponents alloc] init];
        [dateInterval setDay:-1];
        UIImage* thumbnail = nil;
        if (self.totalDays < [self.thumbnails count]) {
            Capture* capture = [self.thumbnails objectAtIndex:self.totalDays];
            thumbnail = capture.thumbnail;
        }
        [rowViews addObject:[CalendarEntryView withFrame:self.calendarEntryViewRect date:self.oldestDate andPhoto:thumbnail]];
        self.oldestDate = [self.calendar dateByAddingComponents:dateInterval toDate:self.oldestDate options:0];
        self.totalDays++;
    }
    return rowViews;
}

- (void)initializeOldestDate {
    NSDateComponents* comps = [self.calendar components:(NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit) fromDate:[NSDate date]];
    self.oldestDate = [self.calendar dateFromComponents:comps];
}

- (void)initializeDateFormatters {
    self.yearFormatter = [[NSDateFormatter alloc] init];
    [self.yearFormatter setDateFormat:@"yyyy"];
    self.monthFormatter = [[NSDateFormatter alloc] init];
    [self.monthFormatter setDateFormat:@"MMMM"];
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
        [self initializeDateFormatters];
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
    self.thumbnails = [self fetchThumbnails];
    self.dragGridView = [DragGridView withFrame:self.view.frame delegate:self rows:[self inititializeDayViews] andRelativeView:self.containerView];
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
    return [self addViewRows];
}

- (NSArray*)needTopRows {
    return [self addViewRows];
}

- (void)removedTopRow:(NSArray*)_row {
    CalendarEntryView* entryView = [_row objectAtIndex:0];
}

- (void)removedBottomRow:(NSArray*)_row {
    CalendarEntryView* entryView = [_row lastObject];
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
