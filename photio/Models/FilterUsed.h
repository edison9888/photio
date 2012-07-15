//
//  FilterUsed.h
//  photio
//
//  Created by Troy Stribling on 6/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Capture, Filter;

@interface FilterUsed : NSManagedObject

@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) Filter *filter;
@property (nonatomic, retain) Capture *capture;

@end
