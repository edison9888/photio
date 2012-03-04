//
//  CalendarViewController.m
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CalendarViewController.h"
#import "ViewGeneral.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CalendarViewController (PrivateAPI)
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CalendarViewController

@synthesize transitionGestureRecognizer, containerView;

+ (id)inView:(UIView*)_containerView {
    return [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil inView:_containerView];;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:_containerView {
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
    [[ViewGeneral instance] dragCalendarToCamera:_drag];
}

- (void)didReleaseRight {    
}

- (void)didReleaseLeft {
}

- (void)didReleaseUp {
}

- (void)didReleaseDown {
    [[ViewGeneral instance] releaseCalendarToCamera];
}

- (void)didSwipeRight {
}

- (void)didSwipeLeft {
}

- (void)didSwipeUp {
}

- (void)didSwipeDown {
    [[ViewGeneral instance] transitionCalendarToCamera];
}

@end
