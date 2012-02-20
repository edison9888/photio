//
//  ImageInspectViewController.m
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//
#import "ImageInspectViewController.h"
#import "UIImage+Resize.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageInspectViewController (PrivateAPI)

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo;
- (void)loadFile:(NSString*)_fileName;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageInspectViewController

@synthesize overlayViewController, capturedImages, imageView;

#pragma mark -
#pragma mark ImageInspectViewController


#pragma mark -
#pragma mark ImageInspectViewController (PrivateAPI)

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error != NULL) {
    }
}

- (void)loadFile:(NSString*)_fileName {
    NSString* pngPath = [NSHomeDirectory() stringByAppendingPathComponent:_fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pngPath]) {
        self.imageView.image = [UIImage imageWithContentsOfFile:pngPath];
    }
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.overlayViewController = [[CameraOverlayViewController alloc] initWithNibName:@"CameraOverlayViewController" bundle:nil];
    self.overlayViewController.overlayDelegate = self;    
    self.capturedImages = [NSMutableArray array];
    [self loadFile:@"Documents/Test.png"];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark Toolbar Actions

- (void)showImagePicker:(UIImagePickerControllerSourceType)sourceType {
    if (self.capturedImages.count > 0) {
        [self.capturedImages removeAllObjects];
    }
    if ([UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [self.overlayViewController setupImagePicker:sourceType];
        [self presentModalViewController:self.overlayViewController.imagePickerController animated:YES];
    }
}

- (IBAction)cameraAction:(id)sender { 
    [self showImagePicker:UIImagePickerControllerSourceTypeCamera];
}

#pragma mark -
#pragma mark OverlayViewControllerDelegate

- (void)didTakePicture:(UIImage*)picture { 
    [self.capturedImages addObject:picture];
}

- (void)didFinishWithCamera { 
    [self dismissModalViewControllerAnimated:YES];
    for (UIImage* picture in self.capturedImages) {
        UIImageWriteToSavedPhotosAlbum(picture, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        UIImage* saveImage = [picture scaleBy:SAVED_IMAGE_SCALE andCropToSize:SAVED_IMAGE_CROP];
        NSString* pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
        [UIImagePNGRepresentation(saveImage) writeToFile:pngPath atomically:YES];
        self.imageView.image = saveImage;
        [self.view addSubview:imageView];        
    }
}

@end
