//
//  ServiceManager.h
//  photio
//
//  Created by Troy Stribling on 6/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ServiceTypeCameraRoll,
    ServiceTypeEMail,
    ServiceTypeTwitter,
    ServiceTypeFacebook,
    ServiceTypeInstagram,
    ServiceTypeTumbler
} ServiceType;

@class Service;

@interface ServiceManager : NSObject

@property(nonatomic, strong) NSArray* loadedServices;

+ (ServiceManager*)instance;
- (NSArray*)services;
- (void)useService:(Service*)_service withCapture:(UIImage*)_capture inViewController:(id)_viewController;

@end
