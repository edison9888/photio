//
//  ImageMetaDataEditView.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentViewController.h"

@class ImageEditControlView;
@class ImageEditCommentView;
@class Capture;

@protocol ImageMetaDataEditViewDelegate;
@class CommentViewController;

@interface ImageMetaDataEditView : UIView <CommentViewControllerDelegate>

@property(nonatomic, weak)   id<ImageMetaDataEditViewDelegate>  delegate;
@property(nonatomic, strong) UIView*                            containerView;
@property(nonatomic, strong) CommentViewController*             commentViewController;
@property(nonatomic, strong) IBOutlet ImageEditControlView*     imageCommentBorderView;
@property(nonatomic, strong) IBOutlet ImageEditControlView*     imageShareView;
@property(nonatomic, strong) IBOutlet UILabel*                  imageCommentLabel;
@property(nonatomic, strong) IBOutlet UIImageView*              imageAddComment;
@property(nonatomic, strong) IBOutlet UIImageView*              imageRating;
@property(nonatomic, assign) BOOL                               starred;
 
+ (id)inView:(UIView*)_containerView withDelegate:(id<ImageMetaDataEditViewDelegate>)_delegate;
- (void)updateComment:(NSString*)_comment;
- (void)updateRating:(NSString*)_rating;
- (IBAction)exportToCameraRoll:(id)sender;
- (IBAction)tweet:(id)sender;
- (IBAction)addComment:(id)sender;
- (IBAction)star:(id)sender;

@end

@protocol ImageMetaDataEditViewDelegate <NSObject>

- (void)exportToCameraRoll;
- (void)saveComment:(NSString*)_comment;
- (void)saveRating:(NSString*)_rating;

@end
