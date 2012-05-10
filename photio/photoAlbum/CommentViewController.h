//
//  CommentViewController.h
//  photio
//
//  Created by Troy Stribling on 5/9/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CommentViewControllerDelegate;

@interface CommentViewController : UIViewController

@property(nonatomic, weak)      id<CommentViewControllerDelegate>   delegate;
@property(nonatomic, weak)      UIView*                             containerView;
@property(nonatomic, strong)    IBOutlet UITextView*                commentTextView;

+ (id)inView:(UIView*)_containerView withDelegate:(id<CommentViewControllerDelegate>)_delegate andComment:(NSString*)_comment;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil inView:(UIView*)_containerView;

@end

@protocol CommentViewControllerDelegate <NSObject>

- (void)saveComment:(NSString*)_comment;

@end