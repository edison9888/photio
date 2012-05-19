//
//  CommentViewController.h
//  photio
//
//  Created by Troy Stribling on 5/9/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageMetaDataEditView;
@protocol CommentViewControllerDelegate;

@interface CommentViewController : UIViewController

@property(nonatomic, weak)      id<CommentViewControllerDelegate>   delegate;
@property(nonatomic, weak)      ImageMetaDataEditView*              metaDataEditView;
@property(nonatomic, strong)    IBOutlet UITextView*                commentTextView;
@property(nonatomic, strong)    IBOutlet UIView*                    containerView;

+ (id)inView:(ImageMetaDataEditView*)_containerView withDelegate:(id<CommentViewControllerDelegate>)_delegate andComment:(NSString*)_comment;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil inView:(ImageMetaDataEditView*)_containerView;

@end

@protocol CommentViewControllerDelegate <NSObject>

@required

- (void)saveComment:(NSString*)_comment;

@end