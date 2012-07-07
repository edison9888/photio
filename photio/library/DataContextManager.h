//
//  DataContextManager.h
//  photio
//
//  Created by Troy Stribling on 6/24/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataContextManager : NSObject

@property(nonatomic, strong) NSManagedObjectContext*    mainObjectContext;

+ (DataContextManager*)instance;
- (NSManagedObjectContext*)createContext;
- (void)mergeChangesWithMainContext:(NSNotification*)notification;

- (void)save;
- (void)saveInContext:(NSManagedObjectContext*)_context;

- (void)deleteObject:(NSManagedObject*)_object;
- (void)deleteObject:(NSManagedObject*)_object inContext:(NSManagedObjectContext*)_context;

- (NSUInteger)count:(NSFetchRequest*)_fetchRequest;
- (NSUInteger)count:(NSFetchRequest*)_fetchRequest inContext:(NSManagedObjectContext*)_context;

- (NSArray*)fetch:(NSFetchRequest*)_fetchRequest;
- (NSArray*)fetch:(NSFetchRequest*)_fetchRequest inContext:(NSManagedObjectContext*)_context;

- (id)fetchFirst:(NSFetchRequest*)_fetchRequest;
- (id)fetchFirst:(NSFetchRequest*)_fetchRequest inContext:(NSManagedObjectContext*)_context;

@end
