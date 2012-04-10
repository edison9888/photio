//
//  Image.h
//  photio
//
//  Created by Troy Stribling on 4/9/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Capture;

@interface Image : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) Capture *capture;

@end
