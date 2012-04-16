//
//  LocalesViewController.m
//  photio
//
//  Created by Troy Stribling on 3/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "LocalesViewController.h"

#import "ViewGeneral.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LocalesViewController (PrivateAPI)

- (NSMutableArray*)setLocalViews;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LocalesViewController

@synthesize containerView, dragGridView;

#pragma mark -
#pragma mark LocalesViewController PrivateAPI

- (NSMutableArray*)setLocalViews {
    return [NSMutableArray arrayWithCapacity:10];
}

#pragma mark -
#pragma mark LocalesViewController

+ (id)inView:(UIView*)_containerView {
    return [[LocalesViewController alloc] initWithNibName:@"LocalesViewController" bundle:nil inView:_containerView];;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:_containerView {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.containerView = _containerView;
        self.view.frame = self.containerView.frame;
        self.dragGridView = [DragGridView withFrame:self.view.frame delegate:self rows:[self setLocalViews] andRelativeView:self.containerView];
        self.dragGridView.userInteractionEnabled = YES;
        [self.view addSubview:self.dragGridView];
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

#pragma mark -
#pragma mark DragGridViewDelegate

- (NSArray*)needBottomRows {
    return [[NSArray alloc] init];
}

- (NSArray*)needTopRows {
    return [[NSArray alloc] init];
}

- (void)topRowChanged:(NSInteger)_newFirstRow {    
}

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] dragLocales:_drag];
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] dragLocales:_drag];
}

- (void)didReleaseRight:(CGPoint)_location {
    [[ViewGeneral instance] releaseLocales];
}

- (void)didReleaseLeft:(CGPoint)_location {
    [[ViewGeneral instance] releaseLocales];
}

- (void)didSwipeRight:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] releaseLocales];
}

- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionLocalesToCamera];
}

- (void)didReachMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] releaseLocales];
}

- (void)didReachMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [[ViewGeneral instance] transitionLocalesToCamera];
}

@end
