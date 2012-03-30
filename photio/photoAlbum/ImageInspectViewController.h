//
//  ImageInspectViewController.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"
#import "StreamOfViews.h"
 
@interface ImageInspectViewController : UIViewController <UIImagePickerControllerDelegate, TransitionGestureRecognizerDelegate, StreamOfViewsDelegate> {
    __weak UIView*                  containerView;
    TransitionGestureRecognizer*    transitionGestureRecognizer;
    StreamOfViews*                  imageView;
    NSMutableArray*                 captures;
}

@property(nonatomic, weak)     UIView*                         containerView;
@property(nonatomic, retain)   TransitionGestureRecognizer*    transitionGestureRecognizer;
@property(nonatomic, retain)   StreamOfViews*                  imageView;
@property(nonatomic, retain)   NSMutableArray*                 captures; 

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (void)addImage:(UIImage*)_picture;
- (BOOL)hasCaptures;

@end
