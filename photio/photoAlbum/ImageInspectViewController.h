//
//  ImageInspectViewController.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"

@interface ImageInspectViewController : UIViewController <UIImagePickerControllerDelegate, TransitionGestureRecognizerDelegate> {
    __weak UIView*                  containerView;
    TransitionGestureRecognizer*    transitionGestureRecognizer;
    UIImageView*                    imageView;
    NSMutableArray*                 captures;
    NSInteger                       captureIndex;
}

@property(nonatomic, weak)      UIView*                         containerView;
@property (nonatomic, retain)   TransitionGestureRecognizer*    transitionGestureRecognizer;
@property(nonatomic, retain)    IBOutlet UIImageView*           imageView;
@property(nonatomic, retain)    NSMutableArray*                 captures;
@property(nonatomic, assign)    NSInteger                       captureIndex;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (void)loadCaptures:(NSMutableArray*)_captures;

@end
