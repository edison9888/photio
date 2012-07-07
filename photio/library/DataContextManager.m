//
//  DataContextManager.m
//  photio
//
//  Created by Troy Stribling on 6/24/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "DataContextManager.h"
#import "PhotioAppDelegate.h"
#import "ViewGeneral.h"

/////////////////////////////////////////////////////////////////////////////////////////
static DataContextManager* thisDataContextManager;

/////////////////////////////////////////////////////////////////////////////////////////
@interface DataContextManager (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation DataContextManager

@synthesize mainObjectContext;

#pragma mark - 
#pragma mark DataContextManager PrivateAPI

#pragma mark - 
#pragma mark DataContextManager

+ (DataContextManager*)instance {	
    @synchronized(self) {
        if (thisDataContextManager == nil) {
            thisDataContextManager = [[self alloc] init]; 
        }
    }
    return thisDataContextManager;
}

- (NSManagedObjectContext*)createContext {
    PhotioAppDelegate* theDelegate = [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext* newMoc = [[NSManagedObjectContext alloc] init];
    [newMoc setPersistentStoreCoordinator:[theDelegate persistentStoreCoordinator]];
    return newMoc;
}


- (void)mergeChangesWithMainContext:(NSNotification*)notification  {
    [self.mainObjectContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:) withObject:notification waitUntilDone:YES];
}

- (void)save {
    [self saveInContext:self.mainObjectContext];
}

- (void)saveInContext:(NSManagedObjectContext*)_context {
    NSError *error = nil;
    if (![_context save:&error]) {
        [ViewGeneral alertOnError:error];
    }
}

- (void)deleteObject:(NSManagedObject*)_object {
    [self deleteObject:_object inContext:self.mainObjectContext];
}

- (void)deleteObject:(NSManagedObject*)_object inContext:(NSManagedObjectContext*)_context {
    [_context deleteObject:_object];
    [self saveInContext:_context];    
}

- (NSUInteger)count:(NSFetchRequest*)_fetchRequest {
    return [self count:_fetchRequest inContext:self.mainObjectContext]; 
}

- (NSUInteger)count:(NSFetchRequest*)_fetchRequest inContext:(NSManagedObjectContext*)_context {
    NSError* error;
    NSUInteger count = [_context countForFetchRequest:_fetchRequest error:&error];
    if (count == NSNotFound) {
        [ViewGeneral alertOnError:error];
        abort();
    }
    return count;
}

- (NSArray*)fetch:(NSFetchRequest*)_fetchRequest {
    return [self fetch:_fetchRequest inContext:self.mainObjectContext];
}

- (NSArray*)fetch:(NSFetchRequest*)_fetchRequest inContext:(NSManagedObjectContext*)_context {
    NSError* error;
    NSArray* fetchResults = [_context executeFetchRequest:_fetchRequest error:&error];
    if (fetchResults == nil) {
        [ViewGeneral alertOnError:error];
        abort();
    }
    return fetchResults;
}

- (id)fetchFirst:(NSFetchRequest*)_fetchRequest {
    return [self fetchFirst:_fetchRequest inContext:self.mainObjectContext];
}

- (id)fetchFirst:(NSFetchRequest*)_fetchRequest inContext:(NSManagedObjectContext*)_context {
    id fetchResult = nil;
    _fetchRequest.fetchLimit = 1;
    NSArray* fetchResults = [self fetch:_fetchRequest inContext:_context];
    if ([fetchResults count] > 0) {
        fetchResult = [fetchResults objectAtIndex:0];
    }
    return fetchResult;
}

@end
