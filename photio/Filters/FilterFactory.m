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
    NSArray* filterClassImageAjustmentControls = [NSArray arrayWithObjects:[NSNumber numberWithInt:FilterTypeSaturation], nil];
    NSArray* filters = [NSArray arrayWithObjects:filterClassImageAjustmentControls, nil];
    NSArray* filterClases = [NSArray arrayWithObjects:[NSNumber numberWithInt:FilterClassImageAjustmentControls], nil];
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
        case FilterTypeSaturation:
            filter = [BuiltInFilter filter:@"CIColorControls" andAttribute:@"inputSaturation"];
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
