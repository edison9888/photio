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
@class Service;
@class ParameterSelectionView;

@protocol ImageMetaDataEditViewDelegate;
@class CommentViewController;

typedef enum {
    EditModeService,
    EditModeAlbum
} EditMode;


@interface ImageMetaDataEditView : UIView <CommentViewControllerDelegate, ParameterSelectionViewDelegate>

@property(nonatomic, weak)   id<ImageMetaDataEditViewDelegate>  delegate;
@property(nonatomic, strong) UIView*                            containerView;
@property(nonatomic, strong) CommentViewController*             commentViewController;
@property(nonatomic, strong) ParameterSelectionView*            paramterSelectionView;
@property(nonatomic, strong) Capture*                           capture;
@property(nonatomic, strong) NSArray*                           albums;
@property(nonatomic, strong) IBOutlet ImageControlView*         imageCommentBorderView;
@property(nonatomic, strong) IBOutlet ImageControlView*         imageShareView;
@property(nonatomic, strong) IBOutlet UILabel*                  imageCommentLabel;
@property(nonatomic, strong) IBOutlet UIImageView*              imageAddComment;
@property(nonatomic, strong) IBOutlet UIImageView*              imageRating;
@property(nonatomic, strong) IBOutlet UIView*                   shareContainerView;
@property(nonatomic, strong) IBOutlet UIView*                   commentContainerView;
@property(nonatomic, assign) CGRect                             initialCommentContainerRect;
@property(nonatomic, assign) EditMode                           editMode;
@property(nonatomic, assign) BOOL                               canceling;
 
+ (id)withDelegate:(id<ImageMetaDataEditViewDelegate>)_delegate andCapture:(Capture*)_capture;

@end

@protocol ImageMetaDataEditViewDelegate <NSObject>

@required

@end
