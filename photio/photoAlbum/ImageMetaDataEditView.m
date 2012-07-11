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
#import "CaptureManager.h"
#import "ParameterSelectionView.h"
#import "ServiceManager.h"
#import "UIView+Extensions.h"
#import "AlbumManager.h"

#define MAX_COMMENT_LINES                   5
#define COMMENT_YOFFSET                     15
#define PARAMETER_VIEW_ANIMATION_DURATION   0.2

typedef enum {
    ImageRatingUnstarred,
    ImageRatingStarred
} ImageRating;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageMetaDataEditView (PrivateAPI)

- (void)updateStar;
- (void)updateComment;
- (void)addCommentText:(NSString*)_comment;
- (void)initializeCommentText;
- (void)showParametersWithTitle:(NSString*)_title;
- (IBAction)showServices:(id)sender;
- (IBAction)showAlbums:(id)sender;
- (IBAction)addComment:(id)sender;
- (IBAction)star:(id)sender;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageMetaDataEditView

@synthesize delegate, containerView, commentViewController, paramterSelectionView, capture, albums, imageShareView, imageCommentBorderView, imageCommentLabel, 
            commentContainerView, shareContainerView, imageAddComment, imageRating, initialCommentContainerRect,
            editMode, exiting;

#pragma mark -
#pragma mark ImageMetaDataEditView (PrivateAPI)

- (void)updateStar {
    switch ([self.capture.rating intValue]) {
        case ImageRatingUnstarred:
            self.imageRating.image = [UIImage imageNamed:@"whitestar.png"];
            self.imageRating.alpha = 0.3;
            break;
        case ImageRatingStarred:
            self.imageRating.image = [UIImage imageNamed:@"yellowstar.png"];
            self.imageRating.alpha = 0.9;
            break;            
    }
    [CaptureManager saveCapture:self.capture];
}

- (void)updateComment {
    if (self.capture.comment) {
        [self addCommentText:self.capture.comment];
    } else {
        [self initializeCommentText];
    }
}

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

- (IBAction)showAlbums:(id)sender {
    self.editMode = EditModeAlbum;
    [self showParametersWithTitle:@"Albums"];
}

- (IBAction)showServices:(id)sender {
    self.editMode = EditModeService;
    [self showParametersWithTitle:@"Export"];
}

- (void)showParametersWithTitle:(NSString*)_title  {
    self.exiting = NO;
    [self.delegate touchEnabled:NO];
    CGRect shareViewRect = self.shareContainerView.frame;
    CGRect commentViewRect = self.commentContainerView.frame;
    __block CGRect showShareViewRect = CGRectMake(shareViewRect.origin.x, -shareViewRect.size.height, shareViewRect.size.width, shareViewRect.size.height);
    __block CGRect showCommentViewRect = CGRectMake(commentViewRect.origin.x, self.frame.size.height, commentViewRect.size.width, commentViewRect.size.height);
    self.paramterSelectionView = [ParameterSelectionView initInView:self 
                                     withDelegate:self 
                                     showAnimation:^{
                                         self.shareContainerView.frame = showShareViewRect;
                                         self.commentContainerView.frame = showCommentViewRect;
                                     }
                                     hideAnimation:^{
                                         if (self.exiting) {
                                            [self showControls];
                                         }
                                         [self.delegate touchEnabled:YES];
                                     }
                                     andTitle:_title
                                 ];
}

- (IBAction)addComment:(id)sender {
    self.commentViewController = [CommentViewController inView:self withDelegate:self andComment:nil];
    self.commentViewController.commentTextView.text = self.imageCommentLabel.text;
}

- (IBAction)star:(id)sender {
    switch ([self.capture.rating intValue]) {
        case ImageRatingUnstarred:
            self.imageRating.image = [UIImage imageNamed:@"yellowstar.png"];
            self.imageRating.alpha = 0.9;
            self.capture.rating = [NSNumber numberWithInt:ImageRatingStarred];
            break;
        case ImageRatingStarred:
            self.imageRating.image = [UIImage imageNamed:@"whitestar.png"];
            self.imageRating.alpha = 0.3;
            self.capture.rating = [NSNumber numberWithInt:ImageRatingUnstarred];
            break;            
    }
    [CaptureManager saveCapture:self.capture];
}

#pragma mark -
#pragma mark ImageMetaDataEditView

+ (id)withDelegate:(id<ImageMetaDataEditViewDelegate>)_delegate andCapture:(Capture *)_capture {
    ImageMetaDataEditView* view = (ImageMetaDataEditView*)[UIView loadView:[self class]];
    view.capture = _capture;
    view.delegate = _delegate;
    return view;
}

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (void)didMoveToSuperview {
    self.initialCommentContainerRect = self.commentContainerView.frame;
    [self updateComment];
    [self updateStar];
}

- (void)showControls {
    CGRect shareViewRect = self.shareContainerView.frame;
    CGRect commentViewRect = self.commentContainerView.frame;
    __block CGRect showShareViewRect = CGRectMake(shareViewRect.origin.x, 0.0, shareViewRect.size.width, shareViewRect.size.height);
    __block CGRect showCommentViewRect = CGRectMake(commentViewRect.origin.x, self.frame.size.height - commentViewRect.size.height, commentViewRect.size.width, commentViewRect.size.height);
    [UIView animateWithDuration:PARAMETER_VIEW_ANIMATION_DURATION
        animations:^{
            self.shareContainerView.frame = showShareViewRect;
            self.commentContainerView.frame = showCommentViewRect;
        } 
        completion:^(BOOL _finished) {
        }
    ];
}

#pragma mark -
#pragma mark CommentViewControllerDelegate

- (void)saveComment:(NSString*)_comment {
    if ([_comment length] > 0) {
        self.capture.comment = _comment;
    } else {
        self.capture.comment = nil;
    }
    [self updateComment];
    [CaptureManager saveCapture:self.capture];
}

#pragma mark -
#pragma mark ParameterSelectionViewDelegate

- (NSArray*)loadParameters {
    switch (self.editMode) {
        case EditModeService:
            return [[ServiceManager instance] services];
            break;
        case EditModeAlbum:
            self.albums = [AlbumManager fetchAlbumsForCapture:self.capture];
            return [AlbumManager albums];
            break;
    }
}

- (void)configureParemeterCell:(ParameterSelectionCell*)_parameterCell withParameter:(id)_parameter {
    switch (self.editMode) {
        case EditModeService:
            _parameterCell.parameterIcon.image = [UIImage imageNamed:[_parameter valueForKey:@"imageFilename"]];
            _parameterCell.parameterLabel.text = [_parameter valueForKey:@"name"];
            break;
        case EditModeAlbum:
            _parameterCell.parameterIcon.image = [UIImage imageNamed:@"select-album"];
            _parameterCell.parameterLabel.text = [_parameter valueForKey:@"name"];
            if ([self.albums containsObject:_parameter]) {
                _parameterCell.parameterIcon.alpha = 0.55;
            } else {
                _parameterCell.parameterIcon.alpha = 0.15;
            }
            break;
    }
}

- (void)selectedParameter:(id)_parameter {
    switch (self.editMode) {
        case EditModeService:
            [[ServiceManager instance] useService:(Service*)_parameter withCapture:self.capture onComplete:^{
                [self showControls];
            }];
            [self.paramterSelectionView removeView];
            break;
        case EditModeAlbum:
            if ([self.albums containsObject:_parameter]) {
                [AlbumManager removeCapture:self.capture fromAlbum:_parameter];
            } else {
                [AlbumManager addCapture:self.capture toAlbum:_parameter];
            }
            [self.paramterSelectionView loadParameters];
            [self.paramterSelectionView reloadData];
            break;
    }
}

- (void)done {
    self.exiting = YES;
    [self.paramterSelectionView removeView];
}

- (BOOL)canEdit {
    switch (self.editMode) {
        case EditModeService:
            return NO;
            break;
        case EditModeAlbum:
            return YES;
            break;
    }
}

- (void)addParameterNamed:(NSString *)_name {
    switch (self.editMode) {
        case EditModeService:
            break;
        case EditModeAlbum:
            [AlbumManager createAlbumNamed:_name];
            break;
    }
}

- (void)deleteParameter:(id)_parameter {
    switch (self.editMode) {
        case EditModeService:
            break;
        case EditModeAlbum:
            [AlbumManager deleteAlbum:_parameter];
            break;
    }
}

@end
