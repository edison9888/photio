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

+ (NSDictionary*)filtersByClass;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation FilterFactory

@synthesize filtersByClass;

#pragma mark - 
#pragma mark FilterFactory PrivateApi

+ (NSDictionary*)filtersByClass {
    NSArray* filterClassAdjustment = [NSArray arrayWithObjects:[NSNumber numberWithInt:FilterTypeVibrance], nil];
    NSArray* filters = [NSArray arrayWithObjects:filterClassAdjustment, nil];
    NSArray* filterClases = [NSArray arrayWithObjects:[NSNumber numberWithInt:FilterClassAjustment], nil];
    return [NSDictionary dictionaryWithObjects:filters forKeys:filterClases];
}

#pragma mark - 
#pragma mark FilterFactory

+ (FilterFactory*)instance {	
    @synchronized(self) {
        if (thisFilterFactory == nil) {
            thisFilterFactory = [[self alloc] init]; 
            thisFilterFactory.filtersByClass = [self filtersByClass];
        }
    }
    return thisFilterFactory;
}

+ (Filter*)filter:(FilterType)_filterType {
    Filter* filter = nil;
    switch (_filterType) {
        case FilterTypeVibrance:
            filter = [BuiltInFilter filter:@"CIVibrance" andAttribute:@"inputAmount"];
            break;
        default:
            break;
    }
    return filter;
}

- (NSArray*)filterClassViews {
    return nil;
}

- (NSArray*)filterViews:(FilterClass)_filterClass {
    return nil;    
}

@end
