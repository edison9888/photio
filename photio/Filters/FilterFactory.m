//
//  FilterFactory.m
//  photio
//
//  Created by Troy Stribling on 5/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "FilterFactory.h"
#import "GPUImage.h"

#import "ViewGeneral.h"
#import "FilterPalette.h"
#import "Filter.h"

/////////////////////////////////////////////////////////////////////////////////////////
static FilterFactory* thisFilterFactory = nil;

/////////////////////////////////////////////////////////////////////////////////////////
@interface FilterFactory (PrivateAPI)

+ (FilterPalette*)filterPalette:(NSNumber*)_filterPalette;
+ (NSArray*)loadFilterClasses;
+ (NSArray*)loadFilters;
+ (UIImage*)outputImageForFilter:(GPUImageOutput<GPUImageInput>*)_filter andImage:(UIImage*)_image;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@interface FilterFactory (Filters)

+ (UIImage*)applyBrightnessFilterWithValue:(NSNumber*)_value toImage:(UIImage*)_image;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation FilterFactory

@synthesize loadedFilterPalettes, loadedFilters;

#pragma mark - 
#pragma mark FilterFactory PrivateApi

+ (FilterPalette*)filterPalette:(NSNumber*)_filterPalette {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"FilterPalette" inManagedObjectContext:[ViewGeneral instance].managedObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"filterPaletteId == %@", _filterPalette]];
    [fetchRequest setFetchLimit:1];
    NSArray* fetchResults = [[ViewGeneral instance] fetchFromManagedObjectContext:fetchRequest];
    return [fetchResults objectAtIndex:0];
}

+ (NSArray*)loadFilterPalettes {
    ViewGeneral* viewGeneral = [ViewGeneral instance];
    
    NSString* filterPaletteFile = [[NSBundle  mainBundle] pathForResource:@"FilterPalettes" ofType:@"plist"];
    NSArray* configuredFilterClasses = [[NSDictionary dictionaryWithContentsOfFile:filterPaletteFile] objectForKey:@"filterPalettes"];
    NSInteger configuredFilterClassCount = [configuredFilterClasses count];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* filterPaletteEntity = [NSEntityDescription entityForName:@"FilterPalette" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
    [fetchRequest setEntity:filterPaletteEntity];   
    NSInteger filterPaletteCount = [viewGeneral countFromManagedObjectContext:fetchRequest];
    
    if (filterPaletteCount < configuredFilterClassCount) {
        for (int i = 0; i < (configuredFilterClassCount - filterPaletteCount); i++) {
            FilterPalette* filterPalette = (FilterPalette*)[NSEntityDescription insertNewObjectForEntityForName:@"FilterPalette" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
            NSDictionary* configuredFilterClass = [configuredFilterClasses objectAtIndex:(filterPaletteCount + i)];
            filterPalette.name              = [configuredFilterClass objectForKey:@"name"];
            filterPalette.filterPaletteId   = [configuredFilterClass objectForKey:@"filterPaletteId"];
            filterPalette.imageFilename     = [configuredFilterClass objectForKey:@"imageFilename"];
            filterPalette.hidden            = [configuredFilterClass objectForKey:@"hidden"];
            filterPalette.usageRate         = [NSNumber numberWithFloat:0.0];
            filterPalette.usageCount        = [NSNumber numberWithFloat:0.0];
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
    NSEntityDescription* filterEntity = [NSEntityDescription entityForName:@"Filter" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
    [fetchRequest setEntity:filterEntity];   
    NSInteger filterCount = [viewGeneral countFromManagedObjectContext:fetchRequest];

    if (filterCount < configuredFilterCount) {
        for (int i = 0; i < (configuredFilterCount - filterCount); i++) {
            Filter* filter = (Filter*)[NSEntityDescription insertNewObjectForEntityForName:@"Filter" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
            NSDictionary* configuredFilter  = [configuredFilters objectAtIndex:(filterCount + i)];
            filter.name                = [configuredFilter objectForKey:@"name"];
            filter.filterId            = [configuredFilter objectForKey:@"filterId"];
            filter.imageFilename       = [configuredFilter objectForKey:@"imageFilename"];
            filter.purchased           = [configuredFilter objectForKey:@"purchased"];
            filter.hidden              = [configuredFilter objectForKey:@"hidden"];
            filter.defaultValue        = [configuredFilter objectForKey:@"defaultValue"];
            filter.minimumValue        = [configuredFilter objectForKey:@"minimumValue"];
            filter.maximumValue        = [configuredFilter objectForKey:@"maximumValue"];
            filter.filterPalette       = [self filterPalette:[configuredFilter objectForKey:@"filterPaletteId"]];
            filter.usageRate           = [NSNumber numberWithFloat:0.0];
            filter.usageCount          = [NSNumber numberWithFloat:0.0];
            [viewGeneral saveManagedObjectContext];
        }
    }

    return [viewGeneral fetchFromManagedObjectContext:fetchRequest];
}

+ (UIImage*)outputImageForFilter:(GPUImageOutput<GPUImageInput>*)_filter andImage:(UIImage*)_image {
    GPUImagePicture* filteredImage = [[GPUImagePicture alloc] initWithImage:_image];
    [filteredImage addTarget:_filter];
    [filteredImage processImage];
    return [_filter imageFromCurrentlyProcessedOutput];
}

#pragma mark - 
#pragma mark FilterFactory

+ (FilterFactory*)instance {	
    @synchronized(self) {
        if (thisFilterFactory == nil) {
            thisFilterFactory = [[self alloc] init];
            thisFilterFactory.loadedFilterPalettes= [self loadFilterPalettes];
            thisFilterFactory.loadedFilters = [self loadFilters];
        }
    }
    return thisFilterFactory;
}

- (FilterPalette*)defaultFilterPalette {
    return [self.loadedFilterPalettes objectAtIndex:FilterPaletteTypeImageAjustmentControls];
}

- (Filter*)defaultFilterForPalette:(FilterPalette*)_filterPalette {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* filterPaletteEntity = [NSEntityDescription entityForName:@"Filter" inManagedObjectContext:[ViewGeneral instance].managedObjectContext];
    [fetchRequest setEntity:filterPaletteEntity];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"usageRate" ascending:NO]]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"filterPalette.filterPaletteId=%@", _filterPalette.filterPaletteId]];
    [fetchRequest setFetchLimit:1];
    return [[[ViewGeneral instance] fetchFromManagedObjectContext:fetchRequest] objectAtIndex:0];
}

- (NSArray*)filterPalettes {
    return self.loadedFilterPalettes;
}

- (NSArray*)filtersForPalette:(FilterPalette*)_filterPalette {
    return [self.loadedFilters filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"filterPalette.filterPaletteId == %@", _filterPalette.filterPaletteId]];    
}

+ (UIImage*)applyFilter:(Filter*)_filter withValue:(NSNumber*)_value toImage:(UIImage*)_image {
    UIImage* outputImage = nil;
    switch ([_filter.filterId intValue]) {
        case FilterTypeBrightness:
            outputImage = [self applyBrightnessFilterWithValue:_value toImage:_image];
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
    return outputImage;
}


#pragma mark - 
#pragma mark FilterFacory Filters

+ (UIImage*)applyBrightnessFilterWithValue:(NSNumber*)_value toImage:(UIImage*)_image {
    GPUImageBrightnessFilter* filter = [[GPUImageBrightnessFilter alloc] init];
    [filter setBrightness:[_value floatValue]];
    return [self outputImageForFilter:filter andImage:_image];
}


@end
