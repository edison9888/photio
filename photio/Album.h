//
//  Album.h
//  photio
//
//  Created by Troy Stribling on 6/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Capture;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSNumber * name;
@property (nonatomic, retain) NSNumber * entries;
@property (nonatomic, retain) Capture *capture;

@end
