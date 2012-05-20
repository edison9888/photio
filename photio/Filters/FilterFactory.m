//
//  FilterFactory.m
//  photio
//
//  Created by Troy Stribling on 5/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "FilterFactory.h"
#import "BuiltInFilter.h"

/////////////////////////////////////////////////////////////////////////////////////////
static FilterFactory* thisFilterFactory = nil;

/////////////////////////////////////////////////////////////////////////////////////////
@interface FilterFactory (PrivateAPI)

+ (NSArray*)loadFilterClasses;
+ (NSArray*)loadFilters;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation FilterFactory

@synthesize filerClasses, filters;

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
            thisFilterFactory.filerClasses = [self loadFilterClasses];
            thisFilterFactory.filters = [self loadFilters];
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
    return [self.filerClasses objectAtIndex:FilterClassImageAjustmentControls];
}

- (NSArray*)filterClasses {
    return self.filerClasses;
}

- (NSArray*)filterViews:(FilterClass)_filterClass {
    return [self.filters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"", [NSNumber numberWithInt:_filterClass]]];    
}

@end
