//
//  ImageDisplay.h
//  photio
//
//  Created by Troy Stribling on 6/27/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Capture;

@interface ImageDisplay : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) Capture *capture;

@end
