//
//  CameraFactory.h
//  photio
//
//  Created by Troy Stribling on 6/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Camera;
@class FilteredCameraViewController;

typedef enum {
    CameraTypeIPhone,
    CameraTypeInstant
} CameraType;

@interface CameraFactory : NSObject

@property(nonatomic, strong) NSArray*   loadedCameras;

+ (CameraFactory*)instance;
+ (void)applyCamera:(Camera*)_camera toViewController:(FilteredCameraViewController*)_fileteredCameraViewController;
- (Camera*)defaultCamera;
- (NSArray*)cameras;

@end
