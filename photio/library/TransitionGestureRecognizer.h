//
//  TransitionGestureRecognizer.h
//  photio
//
//  Created by Troy Stribling on 3/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransitionGestureRecognizer : NSObject {
    UIView*     currentView;
    UIView*     nextView;
    CGPoint     lastTouch;
}

@property (nonatomic, assign) CGPoint   lastTouch;
@property (nonatomic, retain) UIView*   currentView;
@property (nonatomic, retain) UIView*   nextView;

+ (id)initInView:(UIView*)_view andTransitionTo:(UIView*)_nextview;
- (void)touched:(UIPanGestureRecognizer*)_recognizer;

@end

@protocol TransitionGestureRecognizerDelegate <NSObject>

- (void)swipeRight;
- (void)swipeLeft;
- (void)swipeUp;
- (void)swipeDown;

@end