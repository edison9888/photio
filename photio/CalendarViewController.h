//
//  CalendarViewController.h
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"

@interface CalendarViewController : UIViewController <TransitionGestureRecognizerDelegate> {
    __weak UIView*                  containerView;
    TransitionGestureRecognizer*    transitionGestureRecognizer;
    NSCalendar*                     calendar;
}

@property (nonatomic, weak)   UIView*                           containerView;
@property (nonatomic, retain) TransitionGestureRecognizer*      transitionGestureRecognizer;
@property (nonatomic, retain) NSCalendar*                       calendar;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
