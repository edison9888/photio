//
//  EntryViewController.m
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "EntryViewController.h"
#import "ViewGeneral.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EntryViewController (PrivateAPI)
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EntryViewController

@synthesize imageView, transitionGestureRecognizer, containerView;

+ (id)inView:(UIView*)_containerView {
    return [[EntryViewController alloc] initWithNibName:@"EntryViewController" bundle:nil inView:_containerView];;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self.view relativeToView:self.containerView];
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -
#pragma mark TransitionGestureRecognizerDelegate

- (void)didDragRight:(CGPoint)_drag {
}

- (void)didDragLeft:(CGPoint)_drag {    
}

- (void)didDragUp:(CGPoint)_drag {
}

- (void)didDragDown:(CGPoint)_drag {
    [[ViewGeneral instance] dragEntryToCamera:_drag];
}

- (void)didReleaseRight {    
}

- (void)didReleaseLeft {
}

- (void)didReleaseUp {
}

- (void)didReleaseDown {
    [[ViewGeneral instance] releaseEntryToCamera];
}

- (void)didSwipeRight {
}

- (void)didSwipeLeft {
}

- (void)didSwipeUp {
}

- (void)didSwipeDown {
    [[ViewGeneral instance] transitionEntryToCamera];
}

@end
