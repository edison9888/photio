//
//  CalendarEntryView.m
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarEntryView.h"
#import "CalendarDayView.h"
#import "CalendarDayOfWeekView.h"
#import "CalendarDayBackgroundView.h"
#import "NSArray+Extensions.h"
#import "ImageInspectView.h"
#import "Capture.h"
#import "Image.h"
#import "ViewGeneral.h"

#define CALENDAR_ENTRY_DATE_OFFSET_FACTOR     0.075f
#define CALENDAR_ENTRY_DATE_SCALE_FACTOR      0.4f
#define CALENDAR_ENTRY_BORDER                 4.0f
#define CALENDAR_ASPECT_RATIO                 1.2

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarEntryView (PrivateAPI)

- (CGRect)calendarDateViewRect:(CGRect)_cotentFrame;
- (void)initializeDateFormatters;
- (void)openEntryView;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarEntryView

@synthesize dayView, backgroundView, dayOfWeekView, photoView, dayFormatter, dayOfWeekFormatter, date, dayIdentifier;

#pragma mark -
#pragma mark CalendarEntryView PrivatAPI

- (CGRect)calendarDateViewRect:(CGRect)_cotentFrame {
    CGSize dateViewSize = CGSizeMake(CALENDAR_ENTRY_DATE_SCALE_FACTOR * _cotentFrame.size.width, CALENDAR_ASPECT_RATIO * CALENDAR_ENTRY_DATE_SCALE_FACTOR * _cotentFrame.size.width);
    CGPoint dateViewOffset = CGPointMake(_cotentFrame.size.width - dateViewSize.width * (1.0 + CALENDAR_ENTRY_DATE_OFFSET_FACTOR), dateViewSize.width * CALENDAR_ENTRY_DATE_OFFSET_FACTOR);
    return CGRectMake(dateViewOffset.x, dateViewOffset.y, dateViewSize.width, dateViewSize.height);
}

- (void)initializeDateFormatters {
    self.dayFormatter = [[NSDateFormatter alloc] init];
    [self.dayFormatter setDateFormat:@"d"];
    self.dayOfWeekFormatter = [[NSDateFormatter alloc] init];
    [self.dayOfWeekFormatter setDateFormat:@"EEE"];
}

- (void)openEntryView {
    if (self.photoView.image) {
        EntriesView* entries = [EntriesView withFrame:[ViewGeneral instance].containerView.frame andDelegate:self];
        [[ViewGeneral instance].containerView addSubview:entries];
    }
}

#pragma mark -
#pragma mark CalendarEntryView

+ (id)withFrame:(CGRect)_frame date:(NSDate*)_date dayIdentifier:(NSString*)_dayIdentifier andPhoto:(UIImage*)_photo {
    return [[CalendarEntryView alloc] initWithFrame:_frame date:_date dayIdentifier:_dayIdentifier andPhoto:_photo];
}

- (id)initWithFrame:(CGRect)_frame date:(NSDate*)_date dayIdentifier:(NSString*)_dayIdentifier andPhoto:(UIImage*)_photo {
    if ((self = [super initWithFrame:_frame])) {
        self.backgroundColor = [UIColor blackColor];
        [self initializeDateFormatters];
        self.date = _date;
        self.dayIdentifier = _dayIdentifier;

        CGRect contentFrame = CGRectMake(CALENDAR_ENTRY_BORDER, CALENDAR_ENTRY_BORDER, self.frame.size.width - CALENDAR_ENTRY_BORDER, self.frame.size.height - CALENDAR_ENTRY_BORDER);
        UIView* contentView = [[UIView alloc] initWithFrame:contentFrame];
        contentView.backgroundColor = [UIColor colorWithRed:0.15 green:0.15 blue:0.15 alpha:1.0];

        CGRect dayRect = [self calendarDateViewRect:contentFrame];
        NSString* day = [self.dayFormatter stringFromDate:_date];
        self.dayView = [CalendarDayView withFrame:dayRect andDay:day];
        self.backgroundView = [CalendarDayBackgroundView withFrame:dayRect];
  
        NSString* dayOfWeek = [self.dayOfWeekFormatter stringFromDate:_date];
        self.dayOfWeekView = [CalendarDayOfWeekView withFrame:dayRect andDayOfWeek:dayOfWeek];

        [self addSubview:contentView];
        self.photoView = [[UIImageView alloc] initWithFrame:_frame];
        self.photoView.image = _photo;
        
        [contentView addSubview:self.photoView];
        [contentView addSubview:self.backgroundView];
        [contentView addSubview:self.dayView];
        [contentView addSubview:self.dayOfWeekView];
        
        UITapGestureRecognizer* openEntryViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openEntryView)];
        openEntryViewGesture.numberOfTapsRequired = 1;
        openEntryViewGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:openEntryViewGesture];
    }
    return self;    
}

#pragma mark -
#pragma mark EntriesViewControllerDelegates

- (void)deleteEntry:(UIView*)_entry {
}

- (void)didTap:(EntriesView*)_entries {
    [_entries removeFromSuperview];
}

- (NSMutableArray*)loadEntries {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Capture" inManagedObjectContext:[[ViewGeneral instance] managedObjectContext]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"dayIdentifier == %@", self.dayIdentifier]];
    NSError* error;
	NSMutableArray* fetchResults = [[[ViewGeneral instance].managedObjectContext executeFetchRequest:fetchRequest error:&error] mutableCopy];
	if (fetchResults == nil) {
		[[[UIAlertView alloc] initWithTitle:@"Error Retrieving Photos" message:@"Your photos were not retrieved" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
	}
    NSArray* entryViews = [fetchResults mapObjectsUsingBlock:^id(id _obj, NSUInteger _idx){
        Capture* capture = _obj;
        return [ImageInspectView withFrame:[ViewGeneral instance].containerView.frame capture:capture.image.image andLocation:CLLocationCoordinate2DMake([capture.latitude doubleValue], [capture.longitude doubleValue])];
    }];
    return [entryViews mutableCopy];
}

@end
