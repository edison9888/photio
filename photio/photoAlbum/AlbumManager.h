//
//  AlbumManager.h
//  photio
//
//  Created by Troy Stribling on 7/6/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumManager : NSObject

+ (AlbumManager*)instance;
+ (NSArray*)albums;

@end
