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
@class Capture;

typedef void (^CompletionCallback)();

@interface ServiceManager : NSObject

@property(readwrite, copy)   CompletionCallback     onComplete;
@property(nonatomic, strong) NSArray*               loadedServices;

+ (ServiceManager*)instance;
- (NSArray*)services;
- (void)useService:(Service*)_service withCapture:(Capture*)_capture onComplete:(CompletionCallback)_onComplete;

@end
