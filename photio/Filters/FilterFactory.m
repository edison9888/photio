//
//  FilterFactory.m
//  photio
//
//  Created by Troy Stribling on 5/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "FilterFactory.h"
#import "BuiltInFilter.h"
#import "ViewGeneral.h"
#import "FilterClassUsage.h"

/////////////////////////////////////////////////////////////////////////////////////////
static FilterFactory* thisFilterFactory = nil;

/////////////////////////////////////////////////////////////////////////////////////////
@interface FilterFactory (PrivateAPI)

+ (NSArray*)loadFilterClasses;
+ (NSArray*)loadFilters;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation FilterFactory

@synthesize loadedFilerClasses, loadedFilters;

#pragma mark - 
#pragma mark FilterFactory PrivateApi

+ (NSArray*)loadFilterClasses {
    NSString* filterClassFile = [[NSBundle  mainBundle] pathForResource:@"FilterClasses" ofType:@"plist"];
    return [[NSDictionary dictionaryWithContentsOfFile:filterClassFile] objectForKey:@"filterClasses"];
}

+ (NSArray*)loadFilters {
    NSString* filtersFile = [[NSBundle  mainBundle] pathForResource:@"Filters" ofType:@"plist"];
    return [[NSDictionary dictionaryWithContentsOfFile:filtersFile] objectForKey:@"filters"];
}

#pragma mark - 
#pragma mark FilterFactory

+ (FilterFactory*)instance {	
    @synchronized(self) {
        if (thisFilterFactory == nil) {
            thisFilterFactory = [[self alloc] init];
            thisFilterFactory.loadedFilerClasses = [self loadFilterClasses];
            thisFilterFactory.loadedFilters = [self loadFilters];
        }
    }
    return thisFilterFactory;
}

+ (Filter*)filter:(FilterType)_filterType {
    Filter* filter = nil;
    switch (_filterType) {
        case FilterTypeSaturation:
            filter = [BuiltInFilter filter:@"CIColorControls" andAttribute:@"inputSaturation"];
            break;
        default:
            break;
    }
    return filter;
}

- (NSDictionary*)defaultFilterClass {
    return [self.loadedFilerClasses objectAtIndex:FilterClassImageAjustmentControls];
}

- (NSArray*)filterClasses {
    NSInteger loadedFilterClassCount = [self.loadedFilerClasses count];
    NSFetchRequest* countFetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* filterClassEntity = [NSEntityDescription entityForName:@"FilterClassUsage" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
    [countFetchRequest setEntity:filterClassEntity];   
    NSInteger filterClassCount = [[ViewGeneral instance] countFromManagedObjectContext:countFetchRequest]; 
    if (filterClassCount < loadedFilterClassCount) {
        for (int i = 0; i < (loadedFilterClassCount - filterClassCount); i++) {
            FilterClassUsage* filterClass = (FilterClassUsage*)[NSEntityDescription insertNewObjectForEntityForName:@"FilterClassUsage" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
        }
    }
    return self.loadedFilerClasses;
}

- (NSArray*)filters:(FilterClass)_filterClass {
    return [self.loadedFilters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"filterClassId == %@", [NSNumber numberWithInt:_filterClass]]];    
}

@end
