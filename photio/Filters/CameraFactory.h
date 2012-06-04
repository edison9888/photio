//
//  CameraFactory.h
//  photio
//
//  Created by Troy Stribling on 6/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GPUImage.h"
#import "Camera.h"

@class Camera;
@class FilteredCameraViewController;

typedef enum {
    CameraTypeIPhone,
    CameraTypeInstant
} CameraType;

@interface CameraFactory : NSObject

@property(nonatomic, strong) NSArray*                           loadedCameras;
@property(nonatomic, strong) GPUImageStillCamera*               stillCamera;
@property(nonatomic, strong) GPUImageOutput<GPUImageInput>*     filter;

+ (CameraFactory*)instance;
+ (void)setCamera:(Camera*)_camera forView:(GPUImageView*)_imageView;
- (void)captureStillImage:(void(^)(NSData* imageData, NSError* error))_completionHandler;
- (Camera*)defaultCamera;
- (NSArray*)cameras;

@end
