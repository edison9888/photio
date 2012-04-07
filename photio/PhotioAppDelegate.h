//
//  PhotioAppDelegate.h
//  photio
//
//  Created by Troy Stribling on 2/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContainerViewController;

@interface PhotioAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow*                                 window;
@property (strong, nonatomic) ContainerViewController*                  viewController;
@property (nonatomic, strong, readonly) NSManagedObjectModel*           managedObjectModel;
@property (nonatomic, strong, readonly) NSManagedObjectContext*         managedObjectContext;
@property (nonatomic, strong, readonly) NSPersistentStoreCoordinator*   persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
