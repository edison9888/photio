//
//  ImageEditViewController.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StreamOfViews.h"

@interface ImageEditViewController : UIViewController <StreamOfViewsDelegate>

@property(nonatomic, strong) StreamOfViews* streamView;
@property(nonatomic, strong) UIView*        containerView;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil inView:(UIView*)_containerView;
- (IBAction)remove:(id)sender;

@end
