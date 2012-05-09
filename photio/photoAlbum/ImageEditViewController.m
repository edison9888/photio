//
//  ImageEditViewController.m
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageEditViewController.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEditViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEditViewController

@synthesize delegate, removeGesture, singleTapGesture, containerView, streamView, imageMetaDataEditView, imageEditView;

#pragma mark -
#pragma mark ImageEditViewController (PrivateAPI)

#pragma mark -
#pragma mark ImageEditViewController

+ (id)inView:(UIView*)_containerView {
    return [[ImageEditViewController alloc] initWithNibName:@"ImageEditViewController" bundle:nil inView:_containerView];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.containerView = _containerView;
    }
    return self;
}

- (void)updateComment:(NSString*)_comment {
    [self.imageMetaDataEditView updateComment:_comment];
}

- (void)updateRating:(NSString*)_rating {
    [self.imageMetaDataEditView updateRating:_rating];
}

- (IBAction)remove:(id)sender {
    [self.view removeFromSuperview];
}

- (IBAction)singleTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(singleTapImageEditGesture)]) {
        [self.delegate singleTapImageEditGesture];
    }
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [self.singleTapGesture requireGestureRecognizerToFail:self.removeGesture];
    self.imageEditView = [ImageEditView inView:self.view withDelegate:self];
    self.imageMetaDataEditView = [ImageMetaDataEditView inView:self.view withDelegate:self];
    self.streamView = [StreamOfViews withFrame:self.view.frame delegate:self relativeToView:self.containerView];
    [self.streamView addView:self.imageEditView];
    [self.streamView addView:self.imageMetaDataEditView];
    self.streamView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.streamView];
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark StreamOfViewsDelegate

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didReleaseUp:(CGPoint)_location {
}

- (void)didReleaseDown:(CGPoint)_location {
}

- (void)didSwipeUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didReachMaxDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
}

- (void)didReachMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
}

- (void)didRemoveAllViews {
}

#pragma mark -
#pragma mark ImageMetaDataEditView

- (void)exportToCameraRoll {
    [self.delegate exportToCameraRoll];
}

- (void)saveComment:(NSString*)_comment {
    [self.delegate saveComment:_comment];
}

- (void)saveRating:(NSString*)_rating {
    [self.delegate saveRating:_rating];
}

#pragma mark -
#pragma mark ImageEditView

@end
