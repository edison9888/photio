//
//  ImageMetaDataEditView.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewController.h"
#import "ParameterSelectionView.h"

@class ImageControlView;
@class ImageEditCommentView;
@class Capture;

@protocol ImageMetaDataEditViewDelegate;
@class CommentViewController;

@interface ImageMetaDataEditView : UIView <CommentViewControllerDelegate, ParameterSelectionViewDelegate>

@property(nonatomic, weak)   id<ImageMetaDataEditViewDelegate>  delegate;
@property(nonatomic, strong) UIView*                            containerView;
@property(nonatomic, strong) CommentViewController*             commentViewController;
@property(nonatomic, strong) IBOutlet ImageControlView*         imageCommentBorderView;
@property(nonatomic, strong) IBOutlet ImageControlView*         imageShareView;
@property(nonatomic, strong) IBOutlet UILabel*                  imageCommentLabel;
@property(nonatomic, strong) IBOutlet UIImageView*              imageAddComment;
@property(nonatomic, strong) IBOutlet UIImageView*              imageRating;
@property(nonatomic, strong) IBOutlet UIView*                   shareContainerView;
@property(nonatomic, strong) IBOutlet UIView*                   commentContainerView;
@property(nonatomic, assign) BOOL                               starred;
@property(nonatomic, assign) CGRect                             initialCommentContainerRect;
 
+ (id)withDelegate:(id<ImageMetaDataEditViewDelegate>)_delegate;
- (void)updateComment:(NSString*)_comment;
- (void)updateRating:(NSString*)_rating;

@end

@protocol ImageMetaDataEditViewDelegate <NSObject>

@required

- (void)exportToCameraRoll;
- (void)saveComment:(NSString*)_comment;
- (void)saveRating:(NSString*)_rating;

@end
