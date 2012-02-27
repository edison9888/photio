//
//  CameraViewController.m
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CameraViewController.h"
#import "ViewGeneral.h"

#define PICKER_SOURCE_TYPE UIImagePickerControllerSourceTypeCamera

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CameraViewController (PrivateAPI)
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CameraViewController

@synthesize cameraDelegate, imagePickerController, containerView;

#pragma mark -
#pragma mark CameraViewController PrivateAPI

#pragma mark -
#pragma mark CameraViewController

+ (id)inView:(UIView*)_containerView {
    return [[CameraViewController alloc] initWithNibName:@"CameraViewController" bundle:nil inView:_containerView];;
}

+ (BOOL)cameraIsAvailable {
    return [UIImagePickerController isSourceTypeAvailable:PICKER_SOURCE_TYPE];
}

- (id)initWithNibName:(NSString*)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {        
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = PICKER_SOURCE_TYPE;
        self.imagePickerController.showsCameraControls = NO;  
        self.imagePickerController.view.contentMode = UIViewContentModeScaleAspectFill;
        self.imagePickerController.wantsFullScreenLayout = YES;
        self.imagePickerController.cameraViewTransform = CGAffineTransformScale(self.imagePickerController.cameraViewTransform, 1.27, 1.27);
        self.imagePickerController.view.frame = self.containerView.frame;
        self.imagePickerController.cameraOverlayView = self.view;
    }
    return self;
}

- (IBAction)takePhoto:(id)sender {
    [self.imagePickerController takePicture];
}

- (IBAction)done:(id)sender {
    [self.cameraDelegate didFinishWithCamera];
}

- (IBAction)toEntries:(id)sender {
    [[ViewGeneral instance] transitionCameraToEntries];
}

- (IBAction)switchCamera:(id)sender {
    switch (self.imagePickerController.cameraDevice) {
        case UIImagePickerControllerCameraDeviceRear:
            self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            break;
        case UIImagePickerControllerCameraDeviceFront:
            self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            break;
    }
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.imagePickerController viewWillAppear:animated];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.imagePickerController viewDidAppear:animated];
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (self.cameraDelegate)
        [self.cameraDelegate didTakePicture:image];    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker { 
    [self.cameraDelegate didFinishWithCamera];
}

@end

