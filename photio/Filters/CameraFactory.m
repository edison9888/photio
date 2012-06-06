//
//  CameraFactory.m
//  photio
//
//  Created by Troy Stribling on 6/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CameraFactory.h"
#import "FilteredCameraViewController.h"
#import "ViewGeneral.h"

/////////////////////////////////////////////////////////////////////////////////////////
static CameraFactory* thisCameraFactory = nil;

/////////////////////////////////////////////////////////////////////////////////////////
@interface CameraFactory (PrivateAPI)

+ (NSArray*)loadCameras;
+ (void)setCamera:(FilteredCameraViewController*)_filteredCameraViewController filter:(GPUImageOutput<GPUImageInput>*)_filter;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@interface CameraFactory (Cameras)

- (void)setIPhoneCamera:(GPUImageView*)_imageView;
- (void)setInstantCamera:(GPUImageView*)_imageView;
- (void)setPixelCamera:(GPUImageView*)_imageView;
- (void)setBoxCamera:(GPUImageView*)_imageView;
- (void)setPlasticCamera:(GPUImageView*)_imageView;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@interface CameraFactory (ParameterValues)

- (void)setInstantCameraParameterValue:(NSNumber*)_value;
- (void)setPixelCameraParameterValue:(NSNumber*)_value;
- (void)setBoxParameterValue:(NSNumber*)_value;
- (void)setPlasticParameterValue:(NSNumber*)_value;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation CameraFactory

@synthesize loadedCameras, camera, stillCamera, filter;

#pragma mark -
#pragma mark CameraFactory PrivayeApi

+ (NSArray*)loadCameras {
    ViewGeneral* viewGeneral = [ViewGeneral instance];
    
    NSString* cameraFile = [[NSBundle  mainBundle] pathForResource:@"Cameras" ofType:@"plist"];
    NSArray* configuredCameras = [[NSDictionary dictionaryWithContentsOfFile:cameraFile] objectForKey:@"cameras"];
    NSInteger configuredCameraCount = [configuredCameras count];
    
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription* cameraEntity = [NSEntityDescription entityForName:@"Camera" inManagedObjectContext:viewGeneral.managedObjectContext];
    [fetchRequest setEntity:cameraEntity];   
    NSInteger cameraCount = [viewGeneral countFromManagedObjectContext:fetchRequest];
    
    if (cameraCount < configuredCameraCount) {
        for (int i = 0; i < (configuredCameraCount - cameraCount); i++) {
            Camera* camera = (Camera*)[NSEntityDescription insertNewObjectForEntityForName:@"Camera" inManagedObjectContext:viewGeneral.managedObjectContext];
            NSDictionary* configuredCamera = [configuredCameras objectAtIndex:(cameraCount + i)];
            camera.cameraId             = [configuredCamera objectForKey:@"cameraId"];
            camera.name                 = [configuredCamera objectForKey:@"name"];
            camera.imageFilename        = [configuredCamera objectForKey:@"imageFilename"];
            camera.hasParameter         = [configuredCamera objectForKey:@"hasParameter"];
            camera.maximumValue         = [configuredCamera objectForKey:@"maximumValue"];
            camera.minimumValue         = [configuredCamera objectForKey:@"minimumValue"];
            camera.value                = [configuredCamera objectForKey:@"value"];
            camera.hasAutoAdjust        = [configuredCamera objectForKey:@"hasAutoAdjust"];
            camera.autoAdjustEnabled    = [configuredCamera objectForKey:@"autoAdjustEnabled"];
            camera.hidden               = [configuredCamera objectForKey:@"hidden"];
            camera.purchased            = [configuredCamera objectForKey:@"purchased"];
            [viewGeneral saveManagedObjectContext];
        }
    }
    
    return [viewGeneral fetchFromManagedObjectContext:fetchRequest];    
}

- (void)setCameraFilter:(GPUImageOutput<GPUImageInput>*)_filter forView:(GPUImageView*)_imageView {
    if (self.stillCamera) {
        [self.stillCamera stopCameraCapture];
        [self.stillCamera removeAllTargets];
        [self.filter removeAllTargets];
    }
    self.stillCamera = [[GPUImageStillCamera alloc] init];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.filter = _filter;
    [self.filter prepareForImageCapture];    
    [self.stillCamera addTarget:_filter];
    [self.filter addTarget:_imageView];  
    [self.stillCamera startCameraCapture];

}

- (void)captureStillImage:(void(^)(NSData* imageData, NSError* error))_completionHandler {
    [self.stillCamera capturePhotoAsJPEGProcessedUpToFilter:self.filter withCompletionHandler:_completionHandler];
}

#pragma mark -
#pragma mark CameraFactory (Cameras)

- (void)setIPhoneCamera:(GPUImageView*)_imageView {
    GPUImageGammaFilter* gammaFilter = [[GPUImageGammaFilter alloc] init];
    [self setCameraFilter:gammaFilter forView:_imageView];
}

- (void)setInstantCamera:(GPUImageView*)_imageView {
    GPUImageFilterGroup* filterGroup = [[GPUImageFilterGroup alloc] init];
    
    GPUImageSaturationFilter* saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:0.4];
    [saturationFilter prepareForImageCapture];
    
    GPUImageRGBFilter* rgbFilter = [[GPUImageRGBFilter alloc] init];
    [rgbFilter setBlue:0.85];
    [rgbFilter prepareForImageCapture];
    
    GPUImageVignetteFilter* vignetteFilter = [[GPUImageVignetteFilter alloc] init];
    [vignetteFilter setVignetteEnd:0.85];
    [vignetteFilter prepareForImageCapture];
    
    [filterGroup addFilter:saturationFilter];
    [filterGroup addFilter:rgbFilter];
    [filterGroup addFilter:vignetteFilter];
    
    [saturationFilter addTarget:rgbFilter];
    [rgbFilter addTarget:vignetteFilter];
    
    [filterGroup setInitialFilters:[NSArray arrayWithObject:saturationFilter]];
    [filterGroup setTerminalFilter:vignetteFilter];
    
    [self setCameraFilter:filterGroup forView:_imageView];
}

- (void)setPixelCamera:(GPUImageView*)_imageView {
    GPUImageFilterGroup* filterGroup = [[GPUImageFilterGroup alloc] init];

    GPUImageToonFilter* toonFilter = [[GPUImageToonFilter alloc] init];
    [toonFilter prepareForImageCapture];
    
    GPUImageGaussianBlurFilter* gaussianFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [gaussianFilter setBlurSize:1.5];
    [gaussianFilter prepareForImageCapture];

    GPUImagePixellateFilter* pixelFilter = [[GPUImagePixellateFilter alloc] init];
    [pixelFilter setFractionalWidthOfAPixel:0.02];
    [pixelFilter prepareForImageCapture];
    
    [filterGroup addFilter:toonFilter];
    [filterGroup addFilter:gaussianFilter];
    [filterGroup addFilter:pixelFilter];
    
    [toonFilter addTarget:gaussianFilter];
    [gaussianFilter addTarget:pixelFilter];
    
    [filterGroup setInitialFilters:[NSArray arrayWithObject:toonFilter]];
    [filterGroup setTerminalFilter:pixelFilter];
    
    [self setCameraFilter:filterGroup forView:_imageView];
}

- (void)setBoxCamera:(GPUImageView*)_imageView {
    GPUImageFilterGroup* filterGroup = [[GPUImageFilterGroup alloc] init];
    
    GPUImageGrayscaleFilter* greyFilter = [[GPUImageGrayscaleFilter alloc] init];
    [greyFilter prepareForImageCapture];
    
    GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:1.5];
    [contrastFilter prepareForImageCapture];

    GPUImageVignetteFilter* vignetteFilter = [[GPUImageVignetteFilter alloc] init];
    [vignetteFilter setVignetteEnd:0.85];
    [vignetteFilter prepareForImageCapture];

    [filterGroup addFilter:greyFilter];
    [filterGroup addFilter:contrastFilter];
    [filterGroup addFilter:vignetteFilter];
    
    [greyFilter addTarget:vignetteFilter];
    
    [filterGroup setInitialFilters:[NSArray arrayWithObject:greyFilter]];
    [filterGroup setTerminalFilter:vignetteFilter];
    
    [self setCameraFilter:filterGroup forView:_imageView];
}

- (void)setPlasticCamera:(GPUImageView*)_imageView {
    GPUImageFilterGroup* filterGroup = [[GPUImageFilterGroup alloc] init];

    GPUImageSaturationFilter* saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:1.25];
    [saturationFilter prepareForImageCapture];
    
    GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:1.5];
    [contrastFilter prepareForImageCapture];

    GPUImageVignetteFilter* vignetteFilter = [[GPUImageVignetteFilter alloc] init];
    [vignetteFilter setVignetteEnd:0.8];
    [vignetteFilter prepareForImageCapture];
    
    [filterGroup addFilter:saturationFilter];
    [filterGroup addFilter:vignetteFilter];
    
    [saturationFilter addTarget:contrastFilter];
    [contrastFilter addTarget:vignetteFilter];
    
    [filterGroup setInitialFilters:[NSArray arrayWithObject:saturationFilter]];
    [filterGroup setTerminalFilter:vignetteFilter];

    [self setCameraFilter:filterGroup forView:_imageView];
}

#pragma mark -
#pragma mark CameraFactory (ParameterValues)

- (void)setInstantCameraParameterValue:(NSNumber*)_value {    
}

- (void)setPixelCameraParameterValue:(NSNumber*)_value {    
}

- (void)setBoxParameterValue:(NSNumber*)_value {    
}

- (void)setPlasticParameterValue:(NSNumber*)_value {
}


#pragma mark -
#pragma mark CameraFactory

+ (CameraFactory*)instance {
    @synchronized(self) {
        if (thisCameraFactory == nil) {
            thisCameraFactory = [[self alloc] init];
            thisCameraFactory.loadedCameras = [self loadCameras];
        }
    }
    return thisCameraFactory;
}

- (void)setCamera:(Camera*)_camera forView:(GPUImageView*)_imageView {
    self.camera = _camera;
    switch ([_camera.cameraId intValue]) {
        case CameraTypeIPhone:
            [self setIPhoneCamera:_imageView];
            break;
        case CameraTypeInstant:
            [self setInstantCamera:_imageView];
            break;  
        case CameraTypePixel:
            [self setPixelCamera:_imageView];
            break;
        case CameraTypeBox:
            [self setBoxCamera:_imageView];
            break;
        case CameraTypePlastic:
            [self setPlasticCamera:_imageView];
            break;
        default:
            break;
    }
}

- (void)setCameraParmeterValue:(NSNumber*)_value {
    switch ([self.camera.cameraId intValue]) {
        case CameraTypeIPhone:
            break;
        case CameraTypeInstant:
            [self setInstantCameraParameterValue:_value];
            break; 
        case CameraTypePixel:
            break;
        case CameraTypeBox:
            break;
        case CameraTypePlastic:
            break;
        default:
            break;
    }
}

- (Camera*)defaultCamera {
    return [self.loadedCameras objectAtIndex:CameraTypeIPhone];
}

- (NSArray*)cameras {
    return self.loadedCameras;
}


@end
