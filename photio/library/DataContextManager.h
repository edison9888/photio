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
- (void)save;
- (void)deleteObject:(NSManagedObject*)_object;
- (NSArray*)fetch:(NSFetchRequest*)_fetchRequest;
- (NSUInteger)count:(NSFetchRequest*)_fetchRequest;
- (NSManagedObjectContext*)createContext;
- (void)mergeChangesWithMainContext:(NSNotification*)notification;

@end
