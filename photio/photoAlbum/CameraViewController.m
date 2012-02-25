//
//  CameraViewController.m
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CameraViewController.h"

@implementation CameraViewController

@synthesize cameraDelegate, takePictureButton, imagePickerController;


#pragma mark -
#pragma mark CameraViewController

- (IBAction)takePhoto:(id)sender {
    [self.imagePickerController takePicture];
}

- (IBAction)done:(id)sender {
    [self.cameraDelegate didFinishWithCamera];
    self.takePictureButton.enabled = YES;
}

#pragma mark -
#pragma mark UIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {        
        self.imagePickerController = [[UIImagePickerController alloc] init];
        self.imagePickerController.delegate = self;
        self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        self.imagePickerController.showsCameraControls = NO;        
        CGRect overlayViewFrame = self.imagePickerController.cameraOverlayView.frame;
        CGRect newFrame = CGRectMake(0.0, CGRectGetHeight(overlayViewFrame)-self.view.frame.size.height-10.0, CGRectGetWidth(overlayViewFrame), 
                                     self.view.frame.size.height+10.0);
        self.view.frame = newFrame;
        [self.imagePickerController.cameraOverlayView addSubview:self.view];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.imagePickerController viewWillAppear:YES];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [self.imagePickerController viewDidAppear:YES];
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

