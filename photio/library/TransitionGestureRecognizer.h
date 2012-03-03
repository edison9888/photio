//
//  TransitionGestureRecognizer.h
//  photio
//
//  Created by Troy Stribling on 3/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    DragDirectionRight,
    DragDirectionLeft,
    DragDirectionUp,
    DragDirectionDown
} DragDirection;

@protocol TransitionGestureRecognizerDelegate;

@interface TransitionGestureRecognizer : NSObject {
    __weak id<TransitionGestureRecognizerDelegate>  delegate;
    UIPanGestureRecognizer*                         gestureRecognizer;
    __weak UIView*                                  view;
    __weak UIView*                                  relativeView;
    CGPoint                                         lastTouch;
    CGPoint                                         totalDragDistance;
    DragDirection                                   dragDirection;
}

@property (nonatomic, weak)   id<TransitionGestureRecognizerDelegate>   delegate;
@property (nonatomic, assign) CGPoint                                   lastTouch;
@property (nonatomic, weak)   UIView*                                   view;
@property (nonatomic, weak)   UIView*                                   relativeView;
@property (nonatomic, retain) UIPanGestureRecognizer*                   gestureRecognizer;
@property (nonatomic, assign) CGPoint                                   totalDragDistance;
@property (nonatomic, assign) DragDirection                             dragDirection;

+ (id)initWithDelegate:(id<TransitionGestureRecognizerDelegate>)_delegate inView:(UIView*)_view relativeToView:(UIView*)_relativeView;
- (id)initWithDelegate:(id<TransitionGestureRecognizerDelegate>)_delegate inView:(UIView*)_view relativeToView:(UIView*)_relativeView;
- (void)touched:(UIPanGestureRecognizer*)_recognizer;

@end


@protocol TransitionGestureRecognizerDelegate <NSObject>

@optional

- (void)didDragRight:(CGPoint)_drag;
- (void)didDragLeft:(CGPoint)_drag;
- (void)didDragUp:(CGPoint)_drag;
- (void)didDragDown:(CGPoint)_drag;

- (void)didReleaseRight;
- (void)didReleaseLeft;
- (void)didReleaseUp;
- (void)didReleaseDown;

- (void)didSwipeRight;
- (void)didSwipeLeft;
- (void)didSwipeUp;
- (void)didSwipeDown;

@end