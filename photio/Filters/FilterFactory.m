//
//  FilterFactory.m
//  photio
//
//  Created by Troy Stribling on 5/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ViewGeneral.h"
#import "FilterClassUsage.h"
#import "FilterUsage.h"

#import "FilterFactory.h"
#import "BuiltInFilter.h"
#import "VignetteFilter.h"

/////////////////////////////////////////////////////////////////////////////////////////
static FilterFactory* thisFilterFactory = nil;

/////////////////////////////////////////////////////////////////////////////////////////
@interface FilterFactory (PrivateAPI)

+ (FilterClassUsage*)filterClass:(NSNumber*)_filterClass;
+ (NSArray*)loadFilterClasses;
+ (NSArray*)loadFilters;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation FilterFactory

@synthesize loadedFilerClasses, loadedFilters;

#pragma mark - 
#pragma mark FilterFactory PrivateApi

+ (FilterClassUsage*)filterClass:(NSNumber*)_filterClass {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"FilterClassUsage" inManagedObjectContext:[ViewGeneral instance].managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"filterClassId == %@", _filterClass]];
    [fetchRequest setFetchLimit:1];
    NSArray* fetchResults = [[ViewGeneral instance] fetchFromManagedObjectContext:fetchRequest];
    return [fetchResults objectAtIndex:0];
}

+ (NSArray*)loadFilterClasses {
    ViewGeneral* viewGeneral = [ViewGeneral instance];
    
    NSString* filterClassFile = [[NSBundle  mainBundle] pathForResource:@"FilterClasses" ofType:@"plist"];
    NSArray* configuredFilterClasses = [[NSDictionary dictionaryWithContentsOfFile:filterClassFile] objectForKey:@"filterClasses"];
    NSInteger configuredFilterClassCount = [configuredFilterClasses count];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* filterClassEntity = [NSEntityDescription entityForName:@"FilterClassUsage" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
    [fetchRequest setEntity:filterClassEntity];   
    NSInteger filterClassCount = [viewGeneral countFromManagedObjectContext:fetchRequest];
    
    if (filterClassCount < configuredFilterClassCount) {
        for (int i = 0; i < (configuredFilterClassCount - filterClassCount); i++) {
            FilterClassUsage* filterClass = (FilterClassUsage*)[NSEntityDescription insertNewObjectForEntityForName:@"FilterClassUsage" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
            NSDictionary* configuredFilterClass = [configuredFilterClasses objectAtIndex:(filterClassCount + i)];
            filterClass.name          = [configuredFilterClass objectForKey:@"name"];
            filterClass.filterClassId = [configuredFilterClass objectForKey:@"filterClassId"];
            filterClass.imageFilename = [configuredFilterClass objectForKey:@"imageFilename"];
            filterClass.hidden        = [configuredFilterClass objectForKey:@"hidden"];
            filterClass.usageRate     = [NSNumber numberWithFloat:0.0];
            filterClass.usageCount    = [NSNumber numberWithFloat:0.0];
            [viewGeneral saveManagedObjectContext];
        }
    }
    
    return [viewGeneral fetchFromManagedObjectContext:fetchRequest];
}

+ (NSArray*)loadFilters {
    ViewGeneral* viewGeneral = [ViewGeneral instance];

    NSString* filtersFile = [[NSBundle  mainBundle] pathForResource:@"Filters" ofType:@"plist"];
    NSArray* configuredFilters = [[NSDictionary dictionaryWithContentsOfFile:filtersFile] objectForKey:@"filters"];
    NSInteger configuredFilterCount = [configuredFilters count];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* filterClassEntity = [NSEntityDescription entityForName:@"FilterUsage" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
    [fetchRequest setEntity:filterClassEntity];   
    NSInteger filterCount = [viewGeneral countFromManagedObjectContext:fetchRequest];

    if (filterCount < configuredFilterCount) {
        for (int i = 0; i < (configuredFilterCount - filterCount); i++) {
            FilterUsage* filter = (FilterUsage*)[NSEntityDescription insertNewObjectForEntityForName:@"FilterUsage" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
            NSDictionary* configuredFilter  = [configuredFilters objectAtIndex:(filterCount + i)];
            filter.name                = [configuredFilter objectForKey:@"name"];
            filter.filterId            = [configuredFilter objectForKey:@"filterId"];
            filter.imageFilename       = [configuredFilter objectForKey:@"imageFilename"];
            filter.purchased           = [configuredFilter objectForKey:@"purchased"];
            filter.hidden              = [configuredFilter objectForKey:@"hidden"];
            filter.filterClass         = [self filterClass:[configuredFilter objectForKey:@"filterClassId"]];
            filter.usageRate           = [NSNumber numberWithFloat:0.0];
            filter.usageCount          = [NSNumber numberWithFloat:0.0];
            [viewGeneral saveManagedObjectContext];
        }
    }

    return [viewGeneral fetchFromManagedObjectContext:fetchRequest];
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

+ (Filter*)filter:(FilterUsage*)_filter {
    Filter* filter = nil;
    switch ([_filter.filterId intValue]) {
        case FilterTypeExposure:
            filter = [BuiltInFilter filter:[[GPUImageExposureFilter alloc] init] withAttribute:@"exposure"];
            break;
        case FilterTypeSaturation:
            break;
        case FilterTypeContrast:
            break;
        case FilterTypeVignette:
            break;
        default:
            break;
    }
    return filter;
}

- (FilterClassUsage*)defaultFilterClass {
    return [self.loadedFilerClasses objectAtIndex:FilterClassImageAjustmentControls];
}

- (FilterUsage*)defaultFilter:(FilterClassUsage*)_filterClass {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* filterClassEntity = [NSEntityDescription entityForName:@"FilterUsage" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
    [fetchRequest setEntity:filterClassEntity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"usageRate" ascending:NO]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"filterClass.filterClassId=%@", _filterClass.filterClassId]];
    [fetchRequest setFetchLimit:1];
    return [[[ViewGeneral instance] fetchFromManagedObjectContext:fetchRequest] objectAtIndex:0];
}

- (NSArray*)filterClasses {
    return self.loadedFilerClasses;
}

- (NSArray*)filters:(FilterClassUsage*)_filterClass {
    return [self.loadedFilters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"filterClass.filterClassId == %@", _filterClass.filterClassId]];    
}

@end
