//
//  AlbumManager.h
//  photio
//
//  Created by Troy Stribling on 7/6/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Capture;

@interface AlbumManager : NSObject

+ (AlbumManager*)instance;
+ (NSArray*)albums;
+ (void)createAlbumNamed:(NSString*)_albumName;
+ (void)addCapture:(Capture*)_capture;
+ (void)removeCapture:(Capture*)_capture;

@end
