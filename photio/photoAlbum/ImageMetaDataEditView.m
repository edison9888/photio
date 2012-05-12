//
//  ImageMetaDataEditView.m
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageMetaDataEditView.h"
#import "ImageEditControlView.h"
#import "Capture.h"
#import "UIView+Extensions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageMetaDataEditView (PrivateAPI)

- (void)hideShareView;
- (void)showShareView;

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

- (void)showShareView {
    self.imageShareView.hidden = NO;
    self.imageTwitter.hidden = NO;
    self.imageExport.hidden = NO;
    self.imageRating.hidden = NO;
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
    } else {
    }
}

- (void)updateRating:(NSString*)_rating {
    if (_rating) {
        self.starred = YES;
    } else {
        self.starred = YES;
    }
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
}

- (IBAction)star:(id)sender {
    if (self.starred) {
        self.starred = NO;
        self.imageRating.image = [UIImage imageNamed:@"whitestar.png"];
        self.imageRating.alpha = 0.3;
    } else {
        self.starred = YES;
        self.imageRating.image = [UIImage imageNamed:@"yellowstar.png"];
        self.imageRating.alpha = 0.75;
    }
    NSLog(@"Star");
}

#pragma mark -
#pragma mark CommentViewControllerDelegate

- (void)saveComment:(NSString*)_comment {
}

@end
