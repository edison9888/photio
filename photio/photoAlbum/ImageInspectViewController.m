//
//  ImageInspectViewController.m
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//
#import "ImageInspectViewController.h"
#import "ViewGeneral.h"
#import "UIImage+Resize.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageInspectViewController (PrivateAPI)

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo;
- (void)loadFile:(NSString*)_fileName;
- (void)saveToCameraRole:(UIImage*)_capture;
- (void)saveToFile:(UIImage*)_image;
- (UIImage*)saveImage:(UIImage*)_capture;
- (void)setCurrentImage;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageInspectViewController

@synthesize imageView, toolBar, containerView, captures, captureIndex;

#pragma mark -
#pragma mark ImageInspectViewController

+ (id)inView:(UIView*)_containerView {
    return [[ImageInspectViewController alloc] initWithNibName:@"ImageInspectViewController" bundle:nil inView:_containerView];;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.captures = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

- (void)loadCaptures:(NSMutableArray*)_captures {
    [self.captures addObjectsFromArray:_captures];
    if ([self.captures count] > 0) {
        self.captureIndex = [self.captures count] - 1;
        [self setCurrentImage];
    }
}

#pragma mark -
#pragma mark ImageInspectViewController Events

- (IBAction)toCamera:(id)sender {
    [[ViewGeneral instance] transitionInspectImageToCamera];
}

- (IBAction)toEntries:(id)sender {
    [[ViewGeneral instance] transitionInspectImageToEntries];
}

- (IBAction)newImages:(id)sender {
    if (self.captureIndex < [self.captures count] - 1) {
        self.captureIndex++;
        [self setCurrentImage];
    }
}

- (IBAction)oldImages:(id)sender {
    if (self.captureIndex > 0) {
        self.captureIndex--;
        [self setCurrentImage];
   }
}

#pragma mark -
#pragma mark ImageInspectViewController (PrivateAPI)

- (void)loadFile:(NSString*)_fileName {
    NSString* pngPath = [NSHomeDirectory() stringByAppendingPathComponent:_fileName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pngPath]) {
        self.imageView.image = [UIImage imageWithContentsOfFile:pngPath];
    }
}

- (void)image:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo {
    if (error != NULL) {
    }
}

- (void)saveToCameraRole:(UIImage*)_capture {
    UIImageWriteToSavedPhotosAlbum(_capture, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)saveToFile:(UIImage*)_image {
    NSString* pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    [UIImagePNGRepresentation(_image) writeToFile:pngPath atomically:YES];    
}

- (UIImage*)saveImage:(UIImage*)_capture {
    CGSize imageSize = _capture.size;
    CGRect screenBounds = [ViewGeneral screenBounds];
    CGFloat scaleImage = screenBounds.size.height / imageSize.height;
    return [_capture scaleBy:scaleImage andCropToSize:screenBounds.size];
}

- (void)setCurrentImage {
    self.imageView.image = [self saveImage:[self.captures objectAtIndex:self.captureIndex]];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

@end
