//
//  EntriesViewController.m
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "EntriesViewController.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EntriesViewController (PrivateAPI)

- (void)loadEntries;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EntriesViewController

@synthesize containerView, singleTap, delegate, entriesView, diagonalGestures, entries;

#pragma mark -
#pragma mark EntriesViewController

+ (id)inView:(UIView*)_containerView withDelegate:(id<EntriesViewControllerDelegate>)_delegate {
    return [[EntriesViewController alloc] initWithNibName:@"EntriesViewController" bundle:nil inView:_containerView withDelegate:_delegate];;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView withDelegate:(id<EntriesViewControllerDelegate>)_delegate {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.delegate = _delegate;
        [self.containerView addSubview:self.view];
    }
    return self;
}

- (IBAction)didSingleTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(didTap)]) {
        [self.delegate didTap:self];
    }
}

#pragma mark -
#pragma mark EntriesViewController (PrivateAPI)

- (void)loadEntries {
    self.entries = [self.delegate loadEntries];
    for (UIView* entryView in self.entries) {
        [self.entriesView addView:entryView];
    }
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.entriesView = [StreamOfViews withFrame:self.view.frame delegate:self relativeToView:self.containerView];
    self.diagonalGestures = [DiagonalGestureRecognizer initWithDelegate:self];
    [self.entriesView.transitionGestureRecognizer.gestureRecognizer requireGestureRecognizerToFail:self.diagonalGestures];
    [self.view addSubview:self.entriesView];
    [self loadEntries];
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
#pragma mark StreamOfViewsDelegate

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(dragEntries:)]) {
        [self.delegate dragEntries:_drag];
    }
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(dragEntries:)]) {
        [self.delegate dragEntries:_drag];
    }
}

- (void)didReleaseUp:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(releaseEntries)]) {
        [self.delegate releaseEntries];
    }
}

- (void)didReleaseDown:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(releaseEntries)]) {
        [self.delegate releaseEntries];
    }
}

- (void)didSwipeUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(transitionUpFromEntries)]) {
        [self.delegate transitionUpFromEntries];
    }
}

- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(transitionDownFromEntries)]) {
        [self.delegate transitionDownFromEntries];
    }
}

- (void)didReachMaxDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(transitionUpFromEntries)]) {
        [self.delegate transitionUpFromEntries];
    }
}

- (void)didReachMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(transitionDownFromEntries)]) {
        [self.delegate transitionDownFromEntries];
    }
}

- (void)didRemoveAllEntries {
    if ([self.delegate respondsToSelector:@selector(didRemoveAllEntries)]) {
        [self.delegate didRemoveAllEntries];
    }
}

#pragma mark -
#pragma mark DiagonalGestrureRecognizerDelegate

-(void)didCheck {
}

-(void)didDiagonalSwipe {
}

@end
