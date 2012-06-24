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

- (void)save {
    NSError *error = nil;
    if (![self.mainObjectContext save:&error]) {
        [ViewGeneral alertOnError:error];
    }
}

- (void)deleteObject:(NSManagedObject*)_object {
    [self.mainObjectContext deleteObject:_object];
    [self save];    
}

- (NSArray*)fetch:(NSFetchRequest*)_fetchRequest {
    NSError* error;
    NSArray* fetchResults = [self.mainObjectContext executeFetchRequest:_fetchRequest error:&error];
    if (fetchResults == nil) {
        [ViewGeneral alertOnError:error];
        abort();
    }
    return fetchResults;
}

- (NSUInteger)count:(NSFetchRequest*)_fetchRequest {
    NSError* error;
    NSUInteger count = [self.mainObjectContext countForFetchRequest:_fetchRequest error:&error];
    if (count == NSNotFound) {
        [ViewGeneral alertOnError:error];
        abort();
    }
    return count;
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

@end
