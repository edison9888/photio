//
//  AlbumManager.m
//  photio
//
//  Created by Troy Stribling on 7/6/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "AlbumManager.h"
#import "DataContextManager.h"
#import "Album.h"
#import "AlbumCapture.h"
#import "Capture.h"
#import "NSArray+Extensions.h"

/////////////////////////////////////////////////////////////////////////////////////////
static AlbumManager* thisAlbumManager = nil;

/////////////////////////////////////////////////////////////////////////////////////////
@interface AlbumManager (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation AlbumManager

#pragma mark - 
#pragma mark AlbumManager Private

#pragma mark - 
#pragma mark AlbumManager

+ (AlbumManager*)instance {
    @synchronized(self) {
        if (thisAlbumManager == nil) {
            thisAlbumManager = [[self alloc] init];
        }
    }
    return thisAlbumManager;
}

+ (NSArray*)albums {
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Album" inManagedObjectContext:contextManager.mainObjectContext]];
    return [contextManager fetch:fetchRequest];
}

+ (void)createAlbumNamed:(NSString*)_albumName {
    DataContextManager* contextManager = [DataContextManager instance];
    Album* album = (Album*)[NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:contextManager.mainObjectContext];
    album.name = _albumName;
    [contextManager save];
}

+ (void)addCapture:(Capture*)_capture toAlbum:(Album*)_album {
    DataContextManager* contextManager = [DataContextManager instance];
    AlbumCapture* albumCapture = [NSEntityDescription insertNewObjectForEntityForName:@"AlbumCapture" inManagedObjectContext:contextManager.mainObjectContext];
    albumCapture.album = _album;
    albumCapture.capture = _capture;
    [contextManager save];
}

+ (void)removeCapture:(Capture*)_capture fromAlbum:(Album*)_album {
    DataContextManager* contextManager = [DataContextManager instance];
    NSSet* captures = _album.captures;
    NSArray* filteredCaptures = [[captures filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"capture.captureId == %@", _capture.captureId]] allObjects];
    if ([filteredCaptures count] > 1) {
        AlbumCapture* albumCapture = [filteredCaptures objectAtIndex:0];
        [contextManager.mainObjectContext deleteObject:albumCapture];
        [contextManager save];
    }
}

+ (Album*)fetchAlbumNamed:(NSString*)_name {
    DataContextManager* contextManager = [DataContextManager instance];
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"Album" inManagedObjectContext:contextManager.mainObjectContext]];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"name == %@", _name]];
    return [contextManager fetchFirst:fetchRequest];
}

+ (NSArray*)fetchCapturesForAlbum:(Album*)_album {
    return [[_album.captures allObjects] mapObjectsUsingBlock:^id(id _object, NSUInteger _idx) {
        AlbumCapture* albumCapture = _object;
        return albumCapture.capture;
    }];
}

+ (NSArray*)fetchCapturesForAlbum:(Album *)_album withLimit:(NSInteger)_limit {
    NSArray* captures = [_album.captures allObjects];
    NSUInteger maxIndex = _limit;
    if ([captures count] < maxIndex) {
        maxIndex = [captures count];
    }
    NSRange fetchRange = NSMakeRange(0, maxIndex);
    return [[captures objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:fetchRange]] mapObjectsUsingBlock:^id(id _object, NSUInteger _idx) {
        AlbumCapture* albumCapture = _object;
        return albumCapture.capture;
    }];
}

+ (NSArray*)fetchAlbumsForCapture:(Capture*)_capture {
    return [[_capture.albums allObjects] mapObjectsUsingBlock:^id(id _object, NSUInteger _idx) {
        AlbumCapture* albumCapture = _object;
        return albumCapture.capture;
    }];
}

@end
