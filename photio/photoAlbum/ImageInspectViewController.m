//
//  ImageInspectViewController.m
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageInspectViewController.h"
#import "ImageInspectView.h"
#import "UIImage+Resize.h"
#import "Capture.h"
#import "ViewGeneral.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageInspectViewController (PrivateAPI)

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo;
- (void)loadFile:(NSString*)_fileName;
- (void)saveCapture:(ImageInspectView*)_selectedView;
- (CLLocationManager*)locationManager;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageInspectViewController

@synthesize imageView, containerView, delegate, diagonalGestures, locationManager;

#pragma mark -
#pragma mark ImageInspectViewController

+ (id)inView:(UIView*)_containerView withDelegate:(id<ImageInspectViewControllerDelegate>)_delegate {
    return [[ImageInspectViewController alloc] initWithNibName:@"ImageInspectViewController" bundle:nil inView:_containerView withDelegate:_delegate];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView withDelegate:(id<ImageInspectViewControllerDelegate>)_delegate {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.delegate = _delegate;
        self.view.frame = self.containerView.frame;
        self.imageView = [StreamOfViews withFrame:self.view.frame delegate:self relativeToView:_containerView];
        self.diagonalGestures = [DiagonalGestureRecognizer initWithDelegate:self];
        [self.imageView.transitionGestureRecognizer.gestureRecognizer requireGestureRecognizerToFail:self.diagonalGestures];
        [self.view addGestureRecognizer:self.diagonalGestures];
        [self.view addSubview:self.imageView];
        [[self locationManager] startUpdatingLocation];
    }
    return self;
}

- (void)addImage:(UIImage*)_picture {
    [self.imageView addView:[ImageInspectView withFrame:self.view.frame capture:_picture andLocation:[[self.locationManager location] coordinate]]];
}

- (BOOL)hasCaptures {
    return [self.imageView.streamOfViews count] > 0;
}

#pragma mark -
#pragma mark ImageInspectViewController (PrivateAPI)

- (void)loadFile:(NSString*)_fileName {
    NSString* pngPath = [NSHomeDirectory() stringByAppendingPathComponent:_fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pngPath]) {
    }
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error != NULL) {
    }
}

- (CLLocationManager*)locationManager {
    if (locationManager != nil) {
		return locationManager;
	}	
	locationManager = [[CLLocationManager alloc] init];
	[locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
	[locationManager setDelegate:self];	
	return locationManager;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.locationManager = nil;

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
#pragma mark StreamOfViewsDelegate

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(dragInspectImage:)]) {
        [self.delegate dragInspectImage:_drag];
    }
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(dragInspectImage:)]) {
        [self.delegate dragInspectImage:_drag];
    }
}

- (void)didReleaseUp:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(releaseInspectImage)]) {
        [self.delegate releaseInspectImage];
    }
}

- (void)didReleaseDown:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(releaseInspectImage)]) {
        [self.delegate releaseInspectImage];
    }
}

- (void)didSwipeUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(transitionFromInspectImage)]) {
        [self.delegate transitionFromInspectImage];
    }
}

- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(releaseInspectImage)]) {
        [self.delegate releaseInspectImage];
    }
}

- (void)didReachMaxDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(transitionFromInspectImage)]) {
        [self.delegate transitionFromInspectImage];
    }
}

- (void)didReachMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(releaseInspectImage)]) {
        [self.delegate releaseInspectImage];
    }
}

- (void)didRemoveAllViews {
    if ([self.delegate respondsToSelector:@selector(transitionFromInspectImage)]) {
        [self.delegate transitionFromInspectImage];
    }
}

#pragma mark -
#pragma mark DiagonalGestrureRecognizerDelegate

-(void)didCheck {
    UIView* currentImage = [self.imageView displayedView];
}

-(void)didDiagonalSwipe {
    UIView* currentImage = [self.imageView displayedView];
}


@end
