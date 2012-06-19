//
//  ServiceManager.m
//  photio
//
//  Created by Troy Stribling on 6/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ServiceManager.h"
#import "ViewGeneral.h"
#import "Service.h"

/////////////////////////////////////////////////////////////////////////////////////////
static ServiceManager* thisServiceManager = nil;

/////////////////////////////////////////////////////////////////////////////////////////
@interface ServiceManager (PrivateAPI)

+ (NSArray*)loadServices;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation ServiceManager

@synthesize loadedServices;

#pragma mark - 
#pragma mark ServiceManager

+ (NSArray*)loadServices {
    ViewGeneral* viewGeneral = [ViewGeneral instance];
    
    NSString* serviceFile = [[NSBundle  mainBundle] pathForResource:@"Services" ofType:@"plist"];
    NSArray* configuredServices = [[NSDictionary dictionaryWithContentsOfFile:serviceFile] objectForKey:@"services"];
    NSInteger configuredServicesCount = [configuredServices count];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* serviceEntity = [NSEntityDescription entityForName:@"Service" inManagedObjectContext:viewGeneral.managedObjectContext];
    [fetchRequest setEntity:serviceEntity];   
    NSInteger serviceCount = [viewGeneral countFromManagedObjectContext:fetchRequest];
    
    if (serviceCount < configuredServicesCount) {
        for (int i = 0; i < (configuredServicesCount - serviceCount); i++) {
            Service* service = (Service*)[NSEntityDescription insertNewObjectForEntityForName:@"Service" inManagedObjectContext:viewGeneral.managedObjectContext];
            NSDictionary* configuredService = [configuredServices objectAtIndex:(serviceCount + i)];
            service.name              = [configuredService objectForKey:@"name"];
            service.serviceId         = [configuredService objectForKey:@"serviceId"];
            service.imageFilename     = [configuredService objectForKey:@"imageFilename"];
            service.hidden            = [configuredService objectForKey:@"hidden"];
            service.usageRate         = [NSNumber numberWithFloat:0.0];
            service.usageCount        = [NSNumber numberWithFloat:0.0];
            [viewGeneral saveManagedObjectContext];
        }
    }
    
    return [viewGeneral fetchFromManagedObjectContext:fetchRequest];    
}

#pragma mark - 
#pragma mark ServiceManager

+ (ServiceManager*)instance {	
    @synchronized(self) {
        if (thisServiceManager == nil) {
            thisServiceManager = [[self alloc] init];
            thisServiceManager.loadedServices = [self loadServices];
        }
    }
    return thisServiceManager;
}

- (NSArray*)services {
    return self.loadedServices;
}

@end
