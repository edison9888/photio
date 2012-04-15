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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (PrivateAPI)

- (NSMutableArray*)setDayViews;
- (void)setDateFormatters;
- (NSDate*)startDay;
- (NSDate*)startWeek:(NSInteger)_weekOffset;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (CoreData)

- (NSMutableArray*)fetchThumbnails;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarViewController

@synthesize containerView, thumbnails, dragGridView, calendar, firstMonth, lastMonth, year,
            yearFormatter, dayFormatter, dayOfWeekFormatter, monthFormatter;

#pragma mark -
#pragma mark CalendarViewController PrivateAPI

- (NSMutableArray*)setDayViews {
    NSDate* startDate = [self startDay];
    NSInteger totalRowsInView = [ViewGeneral calendarRowsInView];
    NSMutableArray* dayViews = [NSMutableArray arrayWithCapacity:CALENDAR_VIEW_COUNT * totalRowsInView];
    NSInteger currentDay = 0;
    CGRect calendarEntryViewRect = [ViewGeneral calendarEntryViewRect];
    for (int i = 0; i < (CALENDAR_VIEW_COUNT * totalRowsInView); i++) {
        NSMutableArray* daysInRowViews = [NSMutableArray arrayWithCapacity:CALENDAR_DAYS_IN_ROW];
        for (int j = 0; j < CALENDAR_DAYS_IN_ROW; j++) {
            NSDateComponents* dateInterval = [[NSDateComponents alloc] init];
            [dateInterval setDay:-currentDay];
            NSDate* previoustDay = [self.calendar dateByAddingComponents:dateInterval toDate:startDate options:0];
            NSDateComponents* nextDayComponents = [self.calendar components:(NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit) fromDate:previoustDay];
            NSDate* calendarDate = [self.calendar dateFromComponents:nextDayComponents];
            NSString* day = [self.dayFormatter stringFromDate:calendarDate];
            NSString* dayOfWeek = [[self.dayOfWeekFormatter stringFromDate:calendarDate] uppercaseString];
            if (currentDay == 0) {
                self.year = [self.yearFormatter stringFromDate:calendarDate];
                self.firstMonth = [self.monthFormatter stringFromDate:calendarDate];
            }
            if (currentDay == totalRowsInView * CALENDAR_DAYS_IN_ROW) {
                self.lastMonth = [self.monthFormatter stringFromDate:calendarDate];            
            }
            UIImage* thumbnail = nil;
            if (currentDay < [self.thumbnails count]) {
                Capture* capture = [self.thumbnails objectAtIndex:currentDay];
                thumbnail = capture.thumbnail;
            }
            [daysInRowViews addObject:[CalendarEntryView withFrame:calendarEntryViewRect date:day dayOfWeek:dayOfWeek andPhoto:thumbnail]];
            currentDay++;
        }
        [dayViews addObject:daysInRowViews];
    }
    return dayViews;
}

- (void)setDateFormatters {
    self.dayFormatter = [[NSDateFormatter alloc] init];
    [self.dayFormatter setDateFormat:@"d"];
    self.dayOfWeekFormatter = [[NSDateFormatter alloc] init];
    [self.dayOfWeekFormatter setDateFormat:@"EEE"];
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
		// TODO: handle error the error.
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
        [self setDateFormatters];
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.thumbnails = [self fetchThumbnails];
    self.dragGridView = [DragGridView withFrame:self.view.frame delegate:self rows:[self setDayViews] andRelativeView:self.containerView];
    self.dragGridView.userInteractionEnabled = YES;
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

- (NSArray*)needRows {
    return [[NSArray alloc] init];
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
