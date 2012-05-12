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

#define MAX_COMMENT_LINES   5
#define COMMENT_YOFFSET     15
#define COMMENT_RECT        CGRectMake(20.0, 445.0, 280.0, 20.0)

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageMetaDataEditView (PrivateAPI)

- (void)hideShareView;
- (void)addCommentText:(NSString*)_comment;
- (void)initializeCommentText;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageMetaDataEditView

@synthesize delegate, containerView, commentViewController, imageShareView, imageCommentBorderView, imageCommentLabel, 
            imageAddComment, imageTwitter, imageExport, imageRating, starred;

#pragma mark -
#pragma mark ImageMetaDataEditView (PrivateAPI)

- (void)hideShareView {
    self.imageShareView.hidden = YES;
    self.imageTwitter.hidden = YES;
    self.imageExport.hidden = YES;
    self.imageRating.hidden = YES;
}

- (void)addCommentText:(NSString*)_comment {
    CGSize maxSize = CGSizeMake(self.imageCommentLabel.frame.size.width, MAX_COMMENT_LINES * self.imageCommentLabel.frame.size.height);
    CGSize commentSize = [_comment sizeWithFont:[UIFont systemFontOfSize:20.0] constrainedToSize:maxSize lineBreakMode:UILineBreakModeWordWrap];
    CGFloat commentYOffest = self.frame.size.height - commentSize.height - COMMENT_YOFFSET;
    CGRect commentRect = CGRectMake(self.imageCommentLabel.frame.origin.x, commentYOffest, self.imageCommentLabel.frame.size.width, commentSize.height);
    self.imageCommentLabel.frame = commentRect;
    self.imageCommentLabel.text = _comment;
    CGFloat commentBorderYOffset = self.frame.size.height - commentSize.height - 2.0 * COMMENT_YOFFSET;
    CGRect commentBorderRect = CGRectMake(0.0, commentBorderYOffset, self.frame.size.width, commentSize.height + 2.0 * COMMENT_YOFFSET);
    self.imageCommentBorderView.frame = commentBorderRect;
    self.imageAddComment.hidden = YES;
    self.imageCommentLabel.hidden = NO;
}

- (void)initializeCommentText {
    self.imageCommentLabel.frame = COMMENT_RECT;
    self.imageCommentLabel.text = NULL;
    CGFloat commentBorderYOffset = self.frame.size.height - self.imageCommentLabel.frame.size.height - 2.0 * COMMENT_YOFFSET;
    CGRect commentBorderRect = CGRectMake(0.0, commentBorderYOffset, self.frame.size.width, self.imageCommentLabel.frame.size.height + 2.0 * COMMENT_YOFFSET);
    self.imageCommentBorderView.frame = commentBorderRect;
    self.imageAddComment.hidden = NO;
    self.imageCommentLabel.hidden = YES;
}

#pragma mark -
#pragma mark ImageMetaDataEditView

+ (id)inView:(UIView*)_containerView withDelegate:(id<ImageMetaDataEditViewDelegate>)_delegate {
    ImageMetaDataEditView* view = (ImageMetaDataEditView*)[UIView loadView:[self class]];
    view.delegate = _delegate;
    return view;
}

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
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
    } else {
        self.starred = YES;
    }
}

- (void)showShareView {
    self.imageShareView.hidden = NO;
    self.imageTwitter.hidden = NO;
    self.imageExport.hidden = NO;
    self.imageRating.hidden = NO;
}

- (IBAction)exportToCameraRoll:(id)sender {
    [self.delegate exportToCameraRoll];
}

- (IBAction)tweet:(id)sender {
    NSLog(@"Tweet Image");
}

- (IBAction)addComment:(id)sender {
    [self hideShareView];
    self.commentViewController = [CommentViewController inView:self withDelegate:self andComment:nil];
    self.commentViewController.commentTextView.text = self.imageCommentLabel.text;
}

- (IBAction)star:(id)sender {
    if (self.starred) {
        self.starred = NO;
        self.imageRating.image = [UIImage imageNamed:@"whitestar.png"];
        self.imageRating.alpha = 0.3;
        [self.delegate saveRating:@"0"];
    } else {
        self.starred = YES;
        self.imageRating.image = [UIImage imageNamed:@"yellowstar.png"];
        self.imageRating.alpha = 0.9;
        [self.delegate saveRating:@"1"];
    }
}

#pragma mark -
#pragma mark CommentViewControllerDelegate

- (void)saveComment:(NSString*)_comment {
    if ([_comment length] > 0) {
        [self.delegate saveComment:_comment];
        [self addCommentText:_comment];
    }
}

@end
