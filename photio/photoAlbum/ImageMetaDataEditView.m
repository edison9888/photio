//
//  ImageMetaDataEditView.m
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageMetaDataEditView.h"
#import "ImageControlView.h"
#import "Capture.h"
#import "UIView+Extensions.h"

#define MAX_COMMENT_LINES               5
#define COMMENT_YOFFSET                 15

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageMetaDataEditView (PrivateAPI)

- (void)addCommentText:(NSString*)_comment;
- (void)initializeCommentText;
- (IBAction)exportToCameraRoll:(id)sender;
- (IBAction)addComment:(id)sender;
- (IBAction)star:(id)sender;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageMetaDataEditView

@synthesize delegate, containerView, commentViewController, imageShareView, imageCommentBorderView, imageCommentLabel, 
            commentContainerView, shareContainerView, imageAddComment, imageRating, starred, initialCommentContainerRect;

#pragma mark -
#pragma mark ImageMetaDataEditView (PrivateAPI)

- (void)addCommentText:(NSString*)_comment {
    CGSize maxSize = CGSizeMake(self.imageCommentLabel.frame.size.width, MAX_COMMENT_LINES * self.imageCommentLabel.frame.size.height);
    CGSize commentSize = [_comment sizeWithFont:[UIFont systemFontOfSize:20.0] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    
    CGFloat commentContainerBorderYOffset = self.frame.size.height - commentSize.height - 2.0 * COMMENT_YOFFSET;
    CGRect commentContainerBorderRect = CGRectMake(0.0, commentContainerBorderYOffset, self.commentContainerView.frame.size.width, commentSize.height + 2.0 * COMMENT_YOFFSET);
    self.commentContainerView.frame = commentContainerBorderRect;

    CGFloat commentYOffest = self.commentContainerView.frame.size.height - commentSize.height - COMMENT_YOFFSET;
    CGRect commentRect = CGRectMake(self.imageCommentLabel.frame.origin.x, commentYOffest, self.imageCommentLabel.frame.size.width, commentSize.height);
    self.imageCommentLabel.frame = commentRect;
    self.imageCommentLabel.text = _comment;
    
    CGFloat commentBorderYOffset = self.commentContainerView.frame.size.height - commentSize.height - 2.0 * COMMENT_YOFFSET;
    CGRect commentBorderRect = CGRectMake(0.0, commentBorderYOffset, self.commentContainerView.frame.size.width, commentSize.height + 2.0 * COMMENT_YOFFSET);
    self.imageCommentBorderView.frame = commentBorderRect;
        
    self.imageAddComment.hidden = YES;
    self.imageCommentLabel.hidden = NO;
}

- (void)initializeCommentText {
    self.commentContainerView.frame = self.initialCommentContainerRect;
    self.imageCommentBorderView.frame = CGRectMake(0.0, 0.0, self.commentContainerView.frame.size.width, self.commentContainerView.frame.size.height);
    CGFloat commentHeight =  self.commentContainerView.frame.size.height - 2.0 * COMMENT_YOFFSET;
    CGRect commentRect = CGRectMake(self.imageCommentLabel.frame.origin.x, COMMENT_YOFFSET, self.imageCommentLabel.frame.size.width, commentHeight);
    self.imageCommentLabel.frame = commentRect;
    self.imageCommentLabel.text = NULL;
    self.imageAddComment.hidden = NO;
    self.imageCommentLabel.hidden = YES;
}

- (IBAction)exportToCameraRoll:(id)sender {
    [self.delegate exportToCameraRoll];
}

- (IBAction)addComment:(id)sender {
    self.commentViewController = [CommentViewController inView:self withDelegate:self andComment:nil];
    self.commentViewController.commentTextView.text = self.imageCommentLabel.text;
}

- (IBAction)star:(id)sender {
    if (self.starred) {
        self.starred = NO;
        self.imageRating.image = [UIImage imageNamed:@"whitestar.png"];
        self.imageRating.alpha = 0.3;
        [self.delegate saveRating:nil];
    } else {
        self.starred = YES;
        self.imageRating.image = [UIImage imageNamed:@"yellowstar.png"];
        self.imageRating.alpha = 0.9;
        [self.delegate saveRating:@"1"];
    }
}

#pragma mark -
#pragma mark ImageMetaDataEditView

+ (id)withDelegate:(id<ImageMetaDataEditViewDelegate>)_delegate {
    ImageMetaDataEditView* view = (ImageMetaDataEditView*)[UIView loadView:[self class]];
    view.delegate = _delegate;
    return view;
}

- (void)updateComment:(NSString*)_comment {
    if (_comment) {
        [self addCommentText:_comment];
    } else {
        [self initializeCommentText];
    }
}

- (void)updateRating:(NSString*)_rating {
    if (_rating) {
        self.starred = YES;
        self.imageRating.image = [UIImage imageNamed:@"yellowstar.png"];
        self.imageRating.alpha = 0.9;
    } else {
        self.starred = NO;
    }
}

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)didMoveToSuperview {
    self.initialCommentContainerRect = self.commentContainerView.frame;
}

#pragma mark -
#pragma mark CommentViewControllerDelegate

- (void)saveComment:(NSString*)_comment {
    if ([_comment length] > 0) {
        [self.delegate saveComment:_comment];
        [self addCommentText:_comment];
    }
}

#pragma mark -
#pragma mark ParameterSelectionViewDelegate

- (NSArray*)loadParameters {
//    return [[FilterFactory instance] filterPalettes];
    return nil;
}

- (void)configureParemeterCell:(ParameterSelectionCell*)_parameterCell withParameter:(id)_parameter {
//    _parameterCell.parameterIcon.image = [UIImage imageNamed:[_parameter valueForKey:@"imageFilename"]];
//    _parameterCell.parameterLabel.text = [_parameter valueForKey:@"name"];
}

- (void)selectedParameter:(id)_parameter {
}

- (BOOL)addParameters {
    return YES;
}

- (void)addParameter {
}

@end
