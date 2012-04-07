//
//  LocalesViewController.h
//  photio
//
//  Created by Troy Stribling on 3/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragGridView.h"

@interface LocalesViewController : UIViewController <DragGridViewDelegate> {
    __weak UIView*                  containerView;
    DragGridView*                   dragGridView;    
}

@property (nonatomic, weak)   UIView*          containerView;
@property (nonatomic, strong) DragGridView*    dragGridView;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
