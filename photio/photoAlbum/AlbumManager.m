//
//  AlbumManager.m
//  photio
//
//  Created by Troy Stribling on 7/6/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "AlbumManager.h"
#import "DataContextManager.h"

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
    [fetchRequest setEntity:[NSEntityDescription entityForName:@"album" inManagedObjectContext:contextManager.mainObjectContext]];
    return [contextManager fetch:fetchRequest];
}

@end
