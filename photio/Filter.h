//
//  Filter.h
//  photio
//
//  Created by Troy Stribling on 5/28/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FilterPalette;

@interface Filter : NSManagedObject

@property (nonatomic, retain) NSNumber * filterId;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSString * imageFilename;
@property (nonatomic, retain) NSDate * lastUsed;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * purchased;
@property (nonatomic, retain) NSNumber * usageCount;
@property (nonatomic, retain) NSNumber * usageRate;
@property (nonatomic, retain) NSNumber * defaultValue;
@property (nonatomic, retain) NSNumber * minimumValue;
@property (nonatomic, retain) NSNumber * maximumValue;
@property (nonatomic, retain) FilterPalette *filterPalette;

@end
