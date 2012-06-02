//
//  FilteredCameraViewController.m
//  photio
//
//  Created by Troy Stribling on 6/1/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "FilteredCameraViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface FilteredCameraViewController (PrivateAPI)

@end

@implementation FilteredCameraViewController

@synthesize containerView, stillCamera, filter, takePhotoButton;

+ (id)inView:(UIView*)_containerView {
    return [[FilteredCameraViewController alloc] initWithNibName:nil bundle:nil inView:_containerView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.containerView = _containerView;
    }
    return self;
}

- (void)loadView {
	CGRect mainScreenFrame = [[UIScreen mainScreen] bounds];
	GPUImageView* primaryView = [[GPUImageView alloc] initWithFrame:mainScreenFrame];
	primaryView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;        
    self.takePhotoButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.takePhotoButton.frame = CGRectMake(round(mainScreenFrame.size.width / 2.0 - 150.0 / 2.0), mainScreenFrame.size.height - 90.0, 150.0, 40.0);
    [self.takePhotoButton setTitle:@"Snap" forState:UIControlStateNormal];
	self.takePhotoButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [self.takePhotoButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    [self.takePhotoButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];    
    [primaryView addSubview:self.takePhotoButton];    
	self.view = primaryView;	
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.stillCamera = [[GPUImageStillCamera alloc] init];
    self.stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    self.filter = [[GPUImageSketchFilter alloc] init];
    [(GPUImageSketchFilter*)filter setTexelHeight:(1.0 / 1024.0)];
    [(GPUImageSketchFilter*)filter setTexelWidth:(1.0 / 768.0)];
	[self.filter prepareForImageCapture];    
    [self.stillCamera addTarget:filter];
    GPUImageView *filterView = (GPUImageView*) self.view;
    [self.filter addTarget:filterView];    
    [self.stillCamera startCameraCapture];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)updateSliderValue:(id)sender {
}

- (IBAction)takePhoto:(id)sender {
    [self.takePhotoButton setEnabled:NO];    
    [self.stillCamera capturePhotoAsJPEGProcessedUpToFilter:self.filter withCompletionHandler:^(NSData *processedJPEG, NSError *error){
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library writeImageDataToSavedPhotosAlbum:processedJPEG metadata:nil completionBlock:^(NSURL *assetURL, NSError *error2) {
             if (error2) {
                 NSLog(@"ERROR: the image failed to be written");
             }
             else {
                 NSLog(@"PHOTO SAVED - assetURL: %@", assetURL);
             }             
             runOnMainQueueWithoutDeadlocking(^{
                 [self.takePhotoButton setEnabled:YES];
             });
         }];
    }];
}

@end
