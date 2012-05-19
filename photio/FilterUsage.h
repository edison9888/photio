//
//  FilterUsage.h
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface FilterUsage : NSManagedObject

@property (nonatomic, retain) NSNumber * filterId;
@property (nonatomic, retain) NSNumber * usageCount;
@property (nonatomic, retain) NSDate * lastUsed;

@end
