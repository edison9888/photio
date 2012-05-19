//
//  Tag.h
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Capture;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * usageCount;
@property (nonatomic, retain) Capture *capture;

@end
