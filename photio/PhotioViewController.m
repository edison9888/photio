//
//  PhotioViewController.m
//  photio
//
//  Created by Troy Stribling on 2/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "PhotioViewController.h"
#import "UIImage+Resize.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface PhotioViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation PhotioViewController

@synthesize myToolbar, overlayViewController, capturedImages;

#pragma mark -
#pragma mark PhotioViewController (PrivateAPI)

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.overlayViewController = [[CameraOverlayViewController alloc] initWithNibName:@"CameraOverlayViewController" bundle:nil];
    self.overlayViewController.overlay_delegate = self;    
    self.capturedImages = [NSMutableArray array];
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        NSMutableArray *toolbarItems = [NSMutableArray arrayWithCapacity:self.myToolbar.items.count];
        [toolbarItems addObjectsFromArray:self.myToolbar.items];
        [toolbarItems removeObjectAtIndex:2];
        [self.myToolbar setItems:toolbarItems animated:NO];
    }
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
        UIImage* saveImage = [picture resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(320, 427) interpolationQuality:kCGInterpolationHigh];
        UIImage* cropedImage = [saveImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:CGSizeMake(160, 213) interpolationQuality:kCGInterpolationHigh];
        CGSize cropSize = cropedImage.size;
        UIImageView* image = [[UIImageView alloc] initWithImage:[cropedImage croppedImage:CGRectMake((cropSize.width - 160)/2, (cropSize.height - 160)/2, 160, 160)]];
        image.frame = CGRectMake(0, 0, 160, 160);
        image.contentMode = UIViewContentModeCenter;
        [self.view addSubview:image];        
    }
}

@end
