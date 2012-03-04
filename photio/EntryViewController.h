//
//  EntryViewController.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"

@interface EntryViewController : UIViewController <TransitionGestureRecognizerDelegate> {
    __weak UIView*                  containerView;
    UIImageView*                    imageView;
    TransitionGestureRecognizer*    transitionGestureRecognizer;
}

@property (nonatomic, weak)   UIView*                           containerView;
@property (nonatomic, retain) IBOutlet UIImageView*             imageView;
@property (nonatomic, retain) TransitionGestureRecognizer*      transitionGestureRecognizer;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
