//
//  Capture.h
//  photio
//
//  Created by Troy Stribling on 4/7/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Capture : NSManagedObject

@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) id thumbnail;
@property (nonatomic, retain) id image;

@end
