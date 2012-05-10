//
//  CommentViewController.m
//  photio
//
//  Created by Troy Stribling on 5/9/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CommentViewController.h"

@interface CommentViewController (PrivateAPI)

@end

@implementation CommentViewController

@synthesize delegate, containerView, commentTextView;

#pragma mark -
#pragma mark CommentViewController (PrivateAPI)

#pragma mark -
#pragma mark CommentViewController

+ (id)inView:(UIView*)_containerView withDelegate:(id<CommentViewControllerDelegate>)_delegate andComment:(NSString*)_comment {
    CommentViewController* controller = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil inView:_containerView];
    controller.delegate = _delegate;
    controller.commentTextView.text = _comment;
    [controller.containerView addSubview:controller.view];
    return controller;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil inView:(UIView*)_containerView {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.containerView = _containerView;
    }
    return self;
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.commentTextView becomeFirstResponder];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
