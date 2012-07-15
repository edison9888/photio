//
//  AlbumCapture.h
//  photio
//
//  Created by Troy Stribling on 7/7/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Album, Capture;

@interface AlbumCapture : NSManagedObject

@property (nonatomic, retain) Album *album;
@property (nonatomic, retain) Capture *capture;

@end
