//
//  AlbumManager.h
//  photio
//
//  Created by Troy Stribling on 7/6/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Capture;
@class Album;

@interface AlbumManager : NSObject

+ (AlbumManager*)instance;
+ (NSArray*)albums;
+ (void)createAlbumNamed:(NSString*)_albumName;
+ (void)deleteAlbum:(Album*)_album;
+ (void)addCapture:(Capture*)_capture toAlbum:(Album*)_album;
+ (void)removeCapture:(Capture*)_capture fromAlbum:(Album*)_album;
+ (Album*)fetchAlbumNamed:(NSString*)_name;
+ (NSArray*)fetchCapturesForAlbum:(Album*)_album;
+ (NSArray*)fetchCapturesForAlbum:(Album *)_album withLimit:(NSInteger)_limit;
+ (NSArray*)fetchAlbumsForCapture:(Capture*)_capture;

@end
