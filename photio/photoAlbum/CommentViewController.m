//
//  CommentViewController.m
//  photio
//
//  Created by Troy Stribling on 5/9/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CommentViewController.h"
#import "ImageMetaDataEditView.h"

#define COMMENT_VIEW_ANIMATION_DURATION     0.25

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommentViewController (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CommentViewController

@synthesize delegate, metaDataEditView, commentTextView, backgroundView;

#pragma mark -
#pragma mark CommentViewController (PrivateAPI)

- (void)addInputView {
    __block CGRect oldFrame = self.backgroundView.frame;
    self.backgroundView.frame = CGRectMake(oldFrame.origin.x, (oldFrame.origin.y - oldFrame.size.height), oldFrame.size.width, oldFrame.size.height);
    [UIView animateWithDuration:COMMENT_VIEW_ANIMATION_DURATION 
         delay:0
         options:UIViewAnimationOptionCurveEaseOut
         animations:^{
             self.backgroundView.frame = CGRectMake(0.0, 0.0, oldFrame.size.width, oldFrame.size.height);
             [self.commentTextView becomeFirstResponder];
         } 
         completion:^(BOOL _finished) {
         }
    ];
}

- (void)removeInputView {
    __block CGRect oldFrame = self.backgroundView.frame;
    [UIView animateWithDuration:COMMENT_VIEW_ANIMATION_DURATION 
        animations:^{
            self.backgroundView.frame = CGRectMake(oldFrame.origin.x, (oldFrame.origin.y - oldFrame.size.height), oldFrame.size.width, oldFrame.size.height);
            [self.commentTextView resignFirstResponder];
        } 
        completion:^(BOOL _finished) {
            [self.view removeFromSuperview];
            [self.metaDataEditView showShareView];
        }
    ];    
}

#pragma mark -
#pragma mark CommentViewController

+ (id)inView:(ImageMetaDataEditView*)_containerView withDelegate:(id<CommentViewControllerDelegate>)_delegate andComment:(NSString*)_comment {
    CommentViewController* controller = [[CommentViewController alloc] initWithNibName:@"CommentViewController" bundle:nil inView:_containerView];
    controller.delegate = _delegate;
    controller.commentTextView.text = _comment;
    [controller.metaDataEditView addSubview:controller.view];
    return controller;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil inView:(ImageMetaDataEditView*)_containerView {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.metaDataEditView = _containerView;
    }
    return self;
}

- (IBAction)cancel:(id)sender {
    [self removeInputView];
}

- (IBAction)done:(id)sender {
    [self.delegate saveComment:self.commentTextView.text];
    [self removeInputView];
}

#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addInputView];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
