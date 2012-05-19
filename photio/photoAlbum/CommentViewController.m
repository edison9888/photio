//
//  CommentViewController.m
//  photio
//
//  Created by Troy Stribling on 5/9/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CommentViewController.h"
#import "ImageMetaDataEditView.h"

#define COMMENT_VIEW_ANIMATION_SPEED     0.25/100.0
#define SHARE_VIEW_ANIMATION_SPEED       0.125/100.0

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CommentViewController (PrivateAPI)

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CommentViewController

@synthesize delegate, metaDataEditView, commentTextView, containerView;

#pragma mark -
#pragma mark CommentViewController (PrivateAPI)

- (void)addInputView {
    CGRect shareViewRect = self.metaDataEditView.shareContainerView.frame;
    __block CGRect oldFrame = self.containerView.frame;
    __block CGRect newShareViewRect = CGRectMake(shareViewRect.origin.x, -shareViewRect.size.height, shareViewRect.size.width, shareViewRect.size.height);
    self.containerView.frame = CGRectMake(oldFrame.origin.x, (oldFrame.origin.y - oldFrame.size.height), oldFrame.size.width, oldFrame.size.height);
    [UIView animateWithDuration:SHARE_VIEW_ANIMATION_SPEED * oldFrame.size.height
         delay:0
         options:UIViewAnimationOptionCurveEaseOut
         animations:^{
             self.metaDataEditView.shareContainerView.frame = newShareViewRect;
         } 
         completion:^(BOOL _finished) {
             [UIView animateWithDuration:COMMENT_VIEW_ANIMATION_SPEED * oldFrame.size.height 
                 delay:0
                 options:UIViewAnimationOptionCurveEaseOut
                  animations:^{
                      self.containerView.frame = CGRectMake(0.0, 0.0, oldFrame.size.width, oldFrame.size.height);
                      [self.commentTextView becomeFirstResponder];
                  } 
                  completion:^(BOOL _finished) {
                  }
             ];
         }
    ];
}

- (void)removeInputView {
    CGRect shareViewRect = self.metaDataEditView.shareContainerView.frame;
    __block CGRect oldFrame = self.containerView.frame;
    __block CGRect newShareViewRect = CGRectMake(shareViewRect.origin.x, 0.0, shareViewRect.size.width, shareViewRect.size.height);
    [UIView animateWithDuration:COMMENT_VIEW_ANIMATION_SPEED * oldFrame.size.height 
        animations:^{
            self.containerView.frame = CGRectMake(oldFrame.origin.x, (oldFrame.origin.y - oldFrame.size.height), oldFrame.size.width, oldFrame.size.height);
           [self.commentTextView resignFirstResponder];
        } 
        completion:^(BOOL _finished) {
            [UIView animateWithDuration:SHARE_VIEW_ANIMATION_SPEED * oldFrame.size.height
             animations:^{
                 self.metaDataEditView.shareContainerView.frame = newShareViewRect;
             } 
             completion:^(BOOL _finished) {
                 [self.view removeFromSuperview];
             }
            ];    
        }
    ];    
}

- (IBAction)cancel:(id)sender {
    [self removeInputView];
}

- (IBAction)done:(id)sender {
    [self.delegate saveComment:self.commentTextView.text];
    [self removeInputView];
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
