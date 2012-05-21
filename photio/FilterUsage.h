//
//  FilterUsage.h
//  photio
//
//  Created by Troy Stribling on 5/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FilterClassUsage;

@interface FilterUsage : NSManagedObject

@property (nonatomic, retain) NSNumber * filterId;
@property (nonatomic, retain) NSDate * lastUsed;
@property (nonatomic, retain) NSNumber * usageCount;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * purchased;
@property (nonatomic, retain) NSNumber * usageRate;
@property (nonatomic, retain) FilterClassUsage *filterClass;

@end
