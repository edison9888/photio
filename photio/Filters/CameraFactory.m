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
- (NSNumber*)increasingParameter:(NSDictionary*)_parameter fromValue:(NSNumber*)_value;
- (NSNumber*)decreasingParameter:(NSDictionary*)_parameter fromValue:(NSNumber*)_value;
- (NSNumber*)mirroredMaximumParameter:(NSDictionary*)_parameter fromValue:(NSNumber*)_value;
- (NSNumber*)mirroredMinimumParameter:(NSDictionary*)_parameter fromValue:(NSNumber*)_value;

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
@interface CameraFactory (Cameras)

- (void)setIPhoneCamera:(GPUImageView*)_imageView;
- (void)setInstantCamera:(GPUImageView*)_imageView;
- (void)setPixelCamera:(GPUImageView*)_imageView;
- (void)setBoxCamera:(GPUImageView*)_imageView;
- (void)setPlasticCamera:(GPUImageView*)_imageView;

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

- (NSNumber*)increasingParameter:(NSDictionary*)_parameter fromValue:(NSNumber*)_value {
    CGFloat mappedValue = 0.0;
    CGFloat value =[_value floatValue];
    CGFloat initialValue = [[_parameter objectForKey:@"initialValue"] floatValue];
    CGFloat maximumValue = [[_parameter objectForKey:@"maximumValue"] floatValue];
    CGFloat minimumValue = [[_parameter objectForKey:@"minimumValue"] floatValue];
    CGFloat upperRange = (maximumValue - initialValue);
    CGFloat lowerRange = (initialValue - minimumValue);
    if (value > 0.5) {
        mappedValue = 2.0 * upperRange * (value - 0.5) + initialValue; 
    } else {
        mappedValue = 2.0 * lowerRange * value + minimumValue; 
    }
    return [NSNumber numberWithFloat:mappedValue];
}

- (NSNumber*)decreasingParameter:(NSDictionary*)_parameter fromValue:(NSNumber*)_value {
    CGFloat mappedValue = 0.0;
    CGFloat value =[_value floatValue];
    CGFloat initialValue = [[_parameter objectForKey:@"initialValue"] floatValue];
    CGFloat maximumValue = [[_parameter objectForKey:@"maximumValue"] floatValue];
    CGFloat minimumValue = [[_parameter objectForKey:@"minimumValue"] floatValue];
    CGFloat upperRange = (initialValue - minimumValue);
    CGFloat lowerRange = (maximumValue - initialValue);
    if (value > 0.5) {
        mappedValue = initialValue - 2.0 * upperRange * (value - 0.5); 
    } else {
        mappedValue = maximumValue -  2.0 * lowerRange * value; 
    }
    return [NSNumber numberWithFloat:mappedValue];
}


// initial value is equal to maximum value
- (NSNumber*)mirroredMaximumParameter:(NSDictionary*)_parameter fromValue:(NSNumber*)_value {
    CGFloat mappedValue = 0.0;
    CGFloat value =[_value floatValue];
    CGFloat initialValue = [[_parameter objectForKey:@"initialValue"] floatValue];
    CGFloat minimumValue = [[_parameter objectForKey:@"minimumValue"] floatValue];
    CGFloat range = (initialValue - minimumValue);
    if (value > 0.5) {
        mappedValue = initialValue - 2.0 * range * (value - 0.5); 
    } else {
        mappedValue = initialValue - 2.0 * range * (0.5 - value); 
    }
    return [NSNumber numberWithFloat:mappedValue];
}

// initial value is equal to minimum value
- (NSNumber*)mirroredMinimumParameter:(NSDictionary*)_parameter fromValue:(NSNumber*)_value {
    CGFloat newValue = 0.0;
    CGFloat value =[_value floatValue];
    CGFloat initialValue = [[_parameter objectForKey:@"initialValue"] floatValue];
    CGFloat maximumValue = [[_parameter objectForKey:@"maximumValue"] floatValue];
    CGFloat range = (maximumValue - initialValue);
    if (value > 0.5) {
        newValue = initialValue + 2.0 * range * (value - 0.5); 
    } else {
        newValue = initialValue + 2.0 * range * (0.5 - value); 
    }
    return [NSNumber numberWithFloat:newValue];
}


#pragma mark -
#pragma mark CameraFactory (ParameterValues)

- (NSDictionary*)instantCameraParameterValues:(NSNumber*)_value {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Instant"];
    
    NSDictionary* rgbParameters = [parameters objectForKey:@"GPUImageRGBFilter"];
    NSDictionary* blueParameters = [rgbParameters objectForKey:@"Blue"];
    NSDictionary* greenParameters = [rgbParameters objectForKey:@"Green"];
    NSDictionary* redParameters = [rgbParameters objectForKey:@"Red"];
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self increasingParameter:blueParameters fromValue:_value],
                                                                         [self increasingParameter:greenParameters fromValue:_value],
                                                                         [self decreasingParameter:redParameters fromValue:_value], nil]
                                       forKeys:[NSArray arrayWithObjects:@"blue", @"green", @"red", nil]];
}

- (NSDictionary*)pixelCameraParameterValues:(NSNumber*)_value {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Pixel"];
    NSDictionary* pixellateParameters = [[parameters objectForKey:@"GPUImagePixellateFilter"] objectForKey:@"FractionalWidthOfAPixel"];
    NSDictionary* gaussianBlurParameters = [[parameters objectForKey:@"GPUImageGaussianBlurFilter"] objectForKey:@"BlurSize"];
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self increasingParameter:pixellateParameters fromValue:_value],
                                                                         [self increasingParameter:gaussianBlurParameters fromValue:_value], nil]
                         forKeys:[NSArray arrayWithObjects:@"pixelWidth", @"blurSize", nil]];
}

- (NSDictionary*)boxParameterValues:(NSNumber*)_value {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Box"];
    
    NSDictionary* rgbParameters = [parameters objectForKey:@"GPUImageRGBFilter"];
    NSDictionary* blueParameters = [rgbParameters objectForKey:@"Blue"];
    NSDictionary* greenParameters = [rgbParameters objectForKey:@"Green"];
    NSDictionary* redParameters = [rgbParameters objectForKey:@"Red"];

    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self decreasingParameter:blueParameters fromValue:_value],
                                                                         [self increasingParameter:greenParameters fromValue:_value],
                                                                         [self increasingParameter:redParameters fromValue:_value], nil]
                         forKeys:[NSArray arrayWithObjects:@"blue", @"green", @"red", nil]];
}

- (NSDictionary*)plasticParameterValues:(NSNumber*)_value {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Plastic"];

    NSDictionary* rgbParameters = [parameters objectForKey:@"GPUImageRGBFilter"];
    NSDictionary* blueParameters = [rgbParameters objectForKey:@"Blue"];
    NSDictionary* greenParameters = [rgbParameters objectForKey:@"Green"];
    NSDictionary* redParameters = [rgbParameters objectForKey:@"Red"];
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[self increasingParameter:blueParameters fromValue:_value],
                                                [self increasingParameter:greenParameters fromValue:_value],
                                                [self decreasingParameter:redParameters fromValue:_value], nil]
                                       forKeys:[NSArray arrayWithObjects:@"blue", @"green", @"red", nil]];
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
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Pixel"];
    NSDictionary* gaussianBlurParameters = [[parameters objectForKey:@"GPUImageGaussianBlurFilter"] objectForKey:@"BlurSize"];
    NSDictionary* pixelateParameters = [[parameters objectForKey:@"GPUImagePixellateFilter"] objectForKey:@"FractionalWidthOfAPixel"];
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[gaussianBlurParameters objectForKey:@"initialValue"],
                                                                         [pixelateParameters objectForKey:@"initialValue"], nil]
                         forKeys:[NSArray arrayWithObjects:@"blurSize", @"pixelWidth", nil]];
    
}

- (NSDictionary*)initialBoxParameterValues {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Box"];
    
    NSDictionary* contrastParameters = [[parameters objectForKey:@"GPUImageContrastFilter"] objectForKey:@"Contrast"];
    NSDictionary* vignetteParameters = [[parameters objectForKey:@"GPUImageVignetteFilter"] objectForKey:@"VignetteEnd"];
    NSDictionary* rgbParameters = [parameters objectForKey:@"GPUImageRGBFilter"];
    NSDictionary* blueParameters = [rgbParameters objectForKey:@"Blue"];
    
    return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[contrastParameters objectForKey:@"initialValue"],
                                                                         [vignetteParameters objectForKey:@"initialValue"], 
                                                                         [blueParameters objectForKey:@"initialValue"], nil]
                         forKeys:[NSArray arrayWithObjects:@"contrast", @"vignette", @"blue", nil]];
    
}

- (NSDictionary*)initialPlasticParameterValues {
    NSDictionary* parameters = [self.loadedCameraParameters objectForKey:@"Plastic"];
    
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
    [contrastFilter addTarget:vignetteFilter];
    
    [filterGroup setInitialFilters:[NSArray arrayWithObject:saturationFilter]];
    [filterGroup setTerminalFilter:vignetteFilter];
    
    return filterGroup;
}

- (GPUImageOutput<GPUImageInput>*)filterPixelCamera {
    NSDictionary* parameters = [self initialPixelCameraParameterValues];
    GPUImageFilterGroup* filterGroup = [[GPUImageFilterGroup alloc] init];
    
    GPUImageToonFilter* toonFilter = [[GPUImageToonFilter alloc] init];
    [toonFilter prepareForImageCapture];
    
    GPUImageGaussianBlurFilter* gaussianFilter = [[GPUImageGaussianBlurFilter alloc] init];
    [gaussianFilter setBlurSize:[[parameters objectForKey:@"blurSize"] floatValue]];
    [gaussianFilter prepareForImageCapture];
    
    GPUImagePixellateFilter* pixelFilter = [[GPUImagePixellateFilter alloc] init];
    [pixelFilter setFractionalWidthOfAPixel:[[parameters objectForKey:@"pixelWidth"] floatValue]];
    [pixelFilter prepareForImageCapture];
    
    [filterGroup addFilter:gaussianFilter];
    [filterGroup addFilter:toonFilter];
    [filterGroup addFilter:pixelFilter];
    
    [gaussianFilter addTarget:toonFilter];
    [toonFilter addTarget:pixelFilter];
    
    [filterGroup setInitialFilters:[NSArray arrayWithObject:gaussianFilter]];
    [filterGroup setTerminalFilter:pixelFilter];
    
    return filterGroup;
}

- (GPUImageOutput<GPUImageInput>*)filterBoxCamera {
    NSDictionary* parameters = [self initialBoxParameterValues];
    GPUImageFilterGroup* filterGroup = [[GPUImageFilterGroup alloc] init];
    
    GPUImageGrayscaleFilter* greyFilter = [[GPUImageGrayscaleFilter alloc] init];
    [greyFilter prepareForImageCapture];
    
    GPUImageContrastFilter* contrastFilter = [[GPUImageContrastFilter alloc] init];
    [contrastFilter setContrast:[[parameters objectForKey:@"contrast"] floatValue]];
    [contrastFilter prepareForImageCapture];
    
    GPUImageRGBFilter* rgbFilter = [[GPUImageRGBFilter alloc] init];
    [rgbFilter setBlue:[[parameters objectForKey:@"blue"] floatValue]];
    [rgbFilter prepareForImageCapture];

    GPUImageVignetteFilter* vignetteFilter = [[GPUImageVignetteFilter alloc] init];
    [vignetteFilter setVignetteEnd:[[parameters objectForKey:@"vignette"] floatValue]];
    [vignetteFilter prepareForImageCapture];
    
    [filterGroup addFilter:greyFilter];
    [filterGroup addFilter:contrastFilter];
    [filterGroup addFilter:rgbFilter];
    [filterGroup addFilter:vignetteFilter];
    
    [greyFilter addTarget:contrastFilter];
    [contrastFilter addTarget:rgbFilter];
    [rgbFilter addTarget:vignetteFilter];
    
    [filterGroup setInitialFilters:[NSArray arrayWithObject:greyFilter]];
    [filterGroup setTerminalFilter:vignetteFilter];
    
    return filterGroup;
}

- (GPUImageOutput<GPUImageInput>*)filterPlasticCamera {
    NSDictionary* parameters = [self initialPlasticParameterValues];
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
    [filterGroup addFilter:rgbFilter];
    [filterGroup addFilter:contrastFilter];
    [filterGroup addFilter:vignetteFilter];
    
    [saturationFilter addTarget:rgbFilter];
    [rgbFilter addTarget:contrastFilter];
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
    [rgbFilter setGreen:[[parameters objectForKey:@"green"] floatValue]];
    [rgbFilter setRed:[[parameters objectForKey:@"red"] floatValue]];
}

- (void)setPixelCameraParameterValue:(NSNumber*)_value {    
    NSDictionary* parameters = [self pixelCameraParameterValues:_value];
    GPUImageFilterGroup* filterGroup = (GPUImageFilterGroup*)self.filter;
    GPUImageGaussianBlurFilter* gaussianBlurFilter = (GPUImageGaussianBlurFilter*)[filterGroup filterAtIndex:0];
    [gaussianBlurFilter setBlurSize:[[parameters objectForKey:@"blurSize"] floatValue]];
    GPUImagePixellateFilter* pixelateFilter = (GPUImagePixellateFilter*)[filterGroup filterAtIndex:2];
    [pixelateFilter setFractionalWidthOfAPixel:[[parameters objectForKey:@"pixelWidth"] floatValue]];
}

- (void)setBoxParameterValue:(NSNumber*)_value {    
    NSDictionary* parameters = [self boxParameterValues:_value];
    GPUImageFilterGroup* filterGroup = (GPUImageFilterGroup*)self.filter;
    GPUImageRGBFilter* rgbFilter = (GPUImageRGBFilter*)[filterGroup filterAtIndex:2];
    [rgbFilter setBlue:[[parameters objectForKey:@"blue"] floatValue]];
    [rgbFilter setGreen:[[parameters objectForKey:@"green"] floatValue]];
    [rgbFilter setRed:[[parameters objectForKey:@"red"] floatValue]];
}

- (void)setPlasticParameterValue:(NSNumber*)_value {
    NSDictionary* parameters = [self instantCameraParameterValues:_value];
    GPUImageFilterGroup* filterGroup = (GPUImageFilterGroup*)self.filter;
    GPUImageRGBFilter* rgbFilter = (GPUImageRGBFilter*)[filterGroup filterAtIndex:1];
    [rgbFilter setBlue:[[parameters objectForKey:@"blue"] floatValue]];
    [rgbFilter setGreen:[[parameters objectForKey:@"green"] floatValue]];
    [rgbFilter setRed:[[parameters objectForKey:@"red"] floatValue]];
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
            [self setCameraFilter:[[GPUImageGammaFilter alloc] init] forView:_imageView];
            break;
        case CameraTypeInstant:
            [self setCameraFilter:[self filterInstantCamera] forView:_imageView];
            break;  
        case CameraTypePixel:
            [self setCameraFilter:[self filterPixelCamera] forView:_imageView];
            break;
        case CameraTypeBox:
            [self setCameraFilter:[self filterBoxCamera] forView:_imageView];
            break;
        case CameraTypePlastic:
            [self setCameraFilter:[self filterPlasticCamera] forView:_imageView];
            break;
        default:
            break;
    }
    [self setCameraParmeterValue:_camera.value];
}

- (void)setCameraParmeterValue:(NSNumber*)_value {
    switch ([self.camera.cameraId intValue]) {
        case CameraTypeIPhone:
            break;
        case CameraTypeInstant:
            [self setInstantCameraParameterValue:_value];
            break; 
        case CameraTypePixel:
            [self setPixelCameraParameterValue:_value];
            break;
        case CameraTypeBox:
            [self setBoxParameterValue:_value];
            break;
        case CameraTypePlastic:
            [self setPlasticParameterValue:_value];
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
