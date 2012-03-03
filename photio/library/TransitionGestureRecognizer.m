//
//  TransitionGestureRecognizer.m
//  photio
//
//  Created by Troy Stribling on 3/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "TransitionGestureRecognizer.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TransitionGestureRecognizer (PrivateAPI)

- (void)delegateDrag:(CGPoint)_delta withVelocity:(CGPoint)_velocity;
- (void)delegateReleaseWithVelocity:(CGPoint)_velocity;
- (void)delegateSwipeWithVelocity:(CGPoint)_velocity;
- (CGPoint)dragDelta:(CGPoint)_touchPoint;
- (DragDirection)dragDirection:(CGPoint)_velocity;
- (BOOL)detectedSwipe:(CGPoint)_velocity;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TransitionGestureRecognizer 

@synthesize lastTouch, delegate, gestureRecognizer, view, relativeView, totalDragDistance;

#pragma mark -
#pragma mark TransitionGestureRecognizer PrivateAPI

- (void)delegateDrag:(CGPoint)_delta withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didDragDown:)]) {
        [self.delegate didDragDown:_delta];
    }
}

- (void)delegateReleaseWithVelocity:(CGPoint)_velocity {
    
}

- (void)delegateSwipeWithVelocity:(CGPoint)_velocity {
    
}

- (CGPoint)dragDelta:(CGPoint)_touchPoint {
    return CGPointMake(_touchPoint.x - self.lastTouch.x, _touchPoint.y - self.lastTouch.y);
}

- (BOOL)detectedSwipe:(CGPoint)_velocity {
    return NO;
}

- (DragDirection)dragDirection:(CGPoint)_velocity {
    return DragDirectionDown;
}

#pragma mark -
#pragma mark TransitionGestureRecognizer

+ (id)initWithDelegate:(id<TransitionGestureRecognizerDelegate>)_delegate inView:(UIView*)_view relativeToView:(UIView*)_relativeView {
    return [[self alloc] initWithDelegate:_delegate inView:_view relativeToView:(UIView*)_relativeView];
}

- (id)initWithDelegate:(id<TransitionGestureRecognizerDelegate>)_delegate inView:(UIView*)_view relativeToView:(UIView*)_relativeView {
    if (self = [super init]) {
        self.delegate = _delegate;
        self.view = _view;
        self.relativeView = _relativeView;
        self.gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
        [self.view addGestureRecognizer:self.gestureRecognizer];
        self.totalDragDistance = CGPointMake(0.0, 0.0);
    }
    return self;
}

- (void)touched:(UIPanGestureRecognizer*)_recognizer {
    CGPoint velocity = [_recognizer velocityInView:self.relativeView];
    CGPoint touchPoint = [_recognizer locationInView:self.relativeView];
    CGPoint delta = [self dragDelta:touchPoint];
    self.totalDragDistance = CGPointMake(self.totalDragDistance.x + delta.x, self.totalDragDistance.y + delta.y);
    switch (_recognizer.state) {
        case UIGestureRecognizerStateBegan:
            self.lastTouch = touchPoint;
            break;
        case UIGestureRecognizerStateChanged:
            [self delegateDrag:delta withVelocity:velocity];
            self.lastTouch = CGPointMake(touchPoint.x, touchPoint.y);
            break;
        case UIGestureRecognizerStateEnded:
            [self detectedSwipe:velocity] ?  [self delegateSwipeWithVelocity:velocity] : [self delegateReleaseWithVelocity:velocity];
            break;
        default:
            break;
    }
}

@end
