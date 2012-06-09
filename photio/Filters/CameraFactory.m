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
+ (NSDictionary*)loadCameraParemeters;
- (CGFloat)scaledFilterValue:(NSNumber*)_value;
- (NSNumber*)parameter:(NSDictionary*)_parameter fromValue:(NSNumber*)_value;

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
@interface CameraFactory (SetParameterValues)

- (void)setInstantCameraParameterValue:(NSNumber*)_value;
- (void)setPixelCameraParameterValue:(NSNumber*)_value;
- (void)setBoxParameterValue:(NSNumber*)_value;
- (void)setPlasticParameterValue:(NSNumber*)_value;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@interface CameraFactory (ParameterValues)

- (NSDictionary*)instantCameraParameterValues:(NSNumber*)_value;
- (NSDictionary*)pixelCameraParameterValues:(NSNumber*)_value;
- (NSDictionary*)boxParameterValues:(NSNumber*)_value;
- (NSDictionary*)plasticParameterValues:(NSNumber*)_value;

- (NSDictionary*)initialInstantCameraParameterValues;
- (NSDictionary*)initialPixelCameraParameterValues;
- (NSDictionary*)initialBoxParameterValues;
- (NSDictionary*)initialPlasticParameterValues;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@interface CameraFactory (Filters)

- (GPUImageOutput<GPUImageInput>*)filterInstantCamera;
- (GPUImageOutput<GPUImageInput>*)filtertPixelCamera;
- (GPUImageOutput<GPUImageInput>*)filterBoxCamera;
- (GPUImageOutput<GPUImageInput>*)filterPlasticCamera;

@end

/////////////////////////////////////////////////////////////////////////////////////////
@implementation CameraFactory

@synthesize loadedCameras, loadedCameraParameters, camera, stillCamera, filter;

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

+ (NSDictionary*)loadCameraParemeters {
    NSString* cameraFile = [[NSBundle  mainBundle] pathForResource:@"CameraFilterParameters" ofType:@"plist"];
    return [[NSDictionary dictionaryWithContentsOfFile:cameraFile] objectForKey:@"CameraFilterParameters"];
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

- (CGFloat)scaledFilterValue:(NSNumber*)_value {
    CGFloat parameterRange = [self.camera.maximumValue floatValue] - [self.camera.minimumValue floatValue];
    return [_value floatValue ] / parameterRange;
}

- (NSNumber*)parameter:(NSDictionary*)_parameter fromValue:(NSNumber*)_value {
    NSNumber* initialValue = [_parameter objectForKey:@"initialValue"];
    NSNumber* maximumValue = [_parameter objectForKey:@"maximumValue"];
    NSNumber* minimumValue = [_parameter objectForKey:@"minimumValue"];
    CGFloat range = ([maximumValue floatValue] - [minimumValue floatValue]);
    CGFloat relativeValue = ([maximumValue floatValue] - [initialValue floatValue]) / range;
    return [NSNumber numberWithFloat:(range * (relativeValue + ([_value floatValue] - 0.5)))];
}

#pragma mark -
#pragma mark CameraFactory (Cameras)

- (void)setIPhoneCamera:(GPUImageView*)_imageView {
    GPUImageGammaFilter* gammaFilter = [[GPUImageGammaFilter alloc] init];
    [self setCameraFilter:gammaFilter forView:_imageView];
}

- (void)setInstantCamera:(GPUImageView*)_imageView {
    [self setCameraFilter:[self filterInstantCamera] forView:_imageView];
}

- (void)setPixelCamera:(GPUImageView*)_imageView {
    [self setCameraFilter:[self filterPixelCamera] forView:_imageView];
}

- (void)setBoxCamera:(GPUImageView*)_imageView {
    [self setCameraFilter:[self filterBoxCamera] forView:_imageView];
}

- (void)setPlasticCamera:(GPUImageView*)_imageView {
    [self setCameraFilter:[self filterPlasticCamera] forView:_imageView];
}

#pragma mark -
#pragma mark CameraFactory (Filters)

- (GPUImageOutput<GPUImageInput>*)filterInstantCamera {
    NSDictionary* parameters = [self initialInstantCameraParameterValues];
    GPUImageFilterGroup* filterGroup = [[GPUImageFilterGroup alloc] init];
    
    GPUImageSaturationFilter* saturationFilter = [[GPUImageSaturationFilter alloc] init];
    [saturationFilter setSaturation:[[parameters objectForKey:@"saturation"] floatValue]];
    [saturationFilter prepareForImageCapture];
    
    GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:[[parameters objectForKey:@"contrast"] floatValue]];
    [contrastFilter prepareForImageCapture];
    
    GPUImageRGBFilter* rgbFilter = [[GPUImageRGBFilter alloc] init];
    [rgbFilter setBlue:[[parameters objectForKey:@"blue"] floatValue]];
    [rgbFilter prepareForImageCapture];
    
    GPUImageVignetteFilter* vignetteFilter = [[GPUImageVignetteFilter alloc] init];
    [vignetteFilter setVignetteEnd:[[parameters objectForKey:@"vignette"] floatValue]];
    [vignetteFilter prepareForImageCapture];
    
    [filterGroup addFilter:saturationFilter];
    [filterGroup addFilter:contrastFilter];
    [filterGroup addFilter:rgbFilter];
    [filterGroup addFilter:vignetteFilter];
    
    [saturationFilter addTarget:rgbFilter];
    [rgbFilter addTarget:contrastFilter];
    [rgbFilter addTarget:vignetteFilter];
    
    [filterGroup setInitialFilters:[NSArray arrayWithObject:saturationFilter]];
    [filterGroup setTerminalFilter:vignetteFilter];
    
    return filterGroup;
}

- (GPUImageOutput<GPUImageInput>*)filterPixelCamera {
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
    
    return filterGroup;
}

- (GPUImageOutput<GPUImageInput>*)filterBoxCamera {
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
    
    return filterGroup;
}

- (GPUImageOutput<GPUImageInput>*)filterPlasticCamera {
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
    
    return filterGroup;
}


#pragma mark -
#pragma mark CameraFactory (SetParameterValues)

- (void)setInstantCameraParameterValue:(NSNumber*)_value {
    NSDictionary* parameters = [self instantCameraParameterValues:_value];
    GPUImageFilterGroup* filterGroup = (GPUImageFilterGroup*)self.filter;
    GPUImageRGBFilter* rgbFilter = (GPUImageRGBFilter*)[filterGroup filterAtIndex:2];
    [rgbFilter setBlue:[[parameters objectForKey:@"blue"] floatValue]];
}

- (void)setPixelCameraParameterValue:(NSNumber*)_value {    
}

- (void)setBoxParameterValue:(NSNumber*)_value {    
}

- (void)setPlasticParameterValue:(NSNumber*)_value {
}

#pragma mark -
#pragma mark CameraFactory (ParameterValues)

- (NSDictionary*)instantCameraParameterValues:(NSNumber*)_value {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Instant"];
    
    NSDictionary* contrastParameters = [[parameters objectForKey:@"GPUImageContrastFilter"] objectForKey:@"Contrast"];
    NSDictionary* rgbParameters = [parameters objectForKey:@"GPUImageRGBFilter"];
    NSDictionary* blueParameters = [rgbParameters objectForKey:@"Blue"];
    NSDictionary* saturationParameters = [[parameters objectForKey:@"GPUImageSaturationFilter"] objectForKey:@"Saturation"];
    NSDictionary* vignetteParameters = [[parameters objectForKey:@"GPUImageVignetteFilter"] objectForKey:@"VignetteEnd"];
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self parameter:blueParameters fromValue:_value], nil]
                                       forKeys:[NSArray arrayWithObjects:@"blue", nil]];
}

- (NSDictionary*)pixelCameraParameterValues:(NSNumber*)_value {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Pixel"];
    return parameters;    
}

- (NSDictionary*)boxParameterValues:(NSNumber*)_value {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Box"];
    return parameters;    
}

- (NSDictionary*)plasticParameterValues:(NSNumber*)_value {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Plastic"];
    return parameters;    
}

- (NSDictionary*)initialInstantCameraParameterValues {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Instant"];
    
    NSDictionary* contrastParameters = [[parameters objectForKey:@"GPUImageContrastFilter"] objectForKey:@"Contrast"];
    NSDictionary* rgbParameters = [parameters objectForKey:@"GPUImageRGBFilter"];
    NSDictionary* blueParameters = [rgbParameters objectForKey:@"Blue"];
    NSDictionary* saturationParameters = [[parameters objectForKey:@"GPUImageSaturationFilter"] objectForKey:@"Saturation"];
    NSDictionary* vignetteParameters = [[parameters objectForKey:@"GPUImageVignetteFilter"] objectForKey:@"VignetteEnd"];
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[contrastParameters objectForKey:@"initialValue"],
                                                                         [blueParameters objectForKey:@"initialValue"],
                                                                         [saturationParameters objectForKey:@"initialValue"], 
                                                                         [vignetteParameters objectForKey:@"initialValue"], nil]
                         forKeys:[NSArray arrayWithObjects:@"contrast", @"blue", @"saturation", @"vignette", nil]];

}

- (NSDictionary*)initialPixelCameraParameterValues {
    return nil; 
}

- (NSDictionary*)initialBoxParameterValues {
    return nil; 
}

- (NSDictionary*)initialPlasticParameterValues {
    return nil; 
}


#pragma mark -
#pragma mark CameraFactory

+ (CameraFactory*)instance {
    @synchronized(self) {
        if (thisCameraFactory == nil) {
            thisCameraFactory = [[self alloc] init];
            thisCameraFactory.loadedCameras = [self loadCameras];
            thisCameraFactory.loadedCameraParameters = [self loadCameraParemeters];
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
