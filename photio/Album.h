//
//  Album.h
//  photio
//
//  Created by Troy Stribling on 7/6/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Capture;

@interface Album : NSManagedObject

@property (nonatomic, retain) NSNumber * captureCount;
@property (nonatomic, retain) NSNumber * name;
@property (nonatomic, retain) Capture *capture;

@end
