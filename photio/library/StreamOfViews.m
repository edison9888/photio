//
//  StreamOfViews.m
//  photio
//
//  Created by Troy Stribling on 3/25/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "StreamOfViews.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface StreamOfViews (PrivateAPI)

- (UIView*)displayedView;
- (void)dragView:(CGPoint)_drag;
- (void)releaseView;
- (void)moveViewsLeft;
- (void)moveViewsRight;
- (BOOL)canMoveLeft;
- (BOOL)canMoveRight;
- (CGFloat)releaseDuration;
- (CGFloat)transitionDuration;
- (CGRect)inWindow;
- (CGRect)leftOfWindow;
- (CGRect)rightOfWindow;
- (UIView*)leftView;
- (UIView*)rightView;

@end

@implementation StreamOfViews

@synthesize delegate, transitionGestureRecognizer, streamOfViews, inViewIndex, notAnimating;

#pragma mark -
#pragma mark StreamOfViews PrivatAPI

- (UIView*)displayedView {
    return [self.streamOfViews objectAtIndex:self.inViewIndex];
}

- (UIView*)leftView {
    return [self.streamOfViews objectAtIndex:(self.inViewIndex - 1)];
}

- (UIView*)rightView {
    return [self.streamOfViews objectAtIndex:(self.inViewIndex + 1)];
}

- (void)dragView:(CGPoint)_drag {
    if (self.notAnimating) {
        UIView* viewItem = [self displayedView];
        viewItem.transform = CGAffineTransformTranslate(viewItem.transform, _drag.x, _drag.y);
    }
}

- (void)releaseView {
    if (self.notAnimating) {
        self.notAnimating = NO;
        [UIView animateWithDuration:[self releaseDuration]
            delay:0
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                [self displayedView].frame = [self inWindow];
            }
            completion:^(BOOL _finished){
                self.notAnimating = YES;
            }
         ];
    }
 }

- (void)moveViewsLeft {
    if ([self canMoveLeft] && self.notAnimating) {
        self.notAnimating = NO;
        [UIView animateWithDuration:[self transitionDuration]
            delay:0
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                [self rightView].frame = [self inWindow];
                [self displayedView].frame = [self leftOfWindow];
            }
            completion:^(BOOL _finished) {
                self.inViewIndex++;
                self.notAnimating = YES;
            }
         ];
    }
}

- (void)moveViewsRight {
    if ([self canMoveRight] && self.notAnimating) {
        self.notAnimating = NO;
        [UIView animateWithDuration:[self transitionDuration]
            delay:0
            options:UIViewAnimationOptionCurveEaseOut
            animations:^{
                [self leftView].frame = [self inWindow];
                [self displayedView].frame = [self rightOfWindow];
            }
            completion:^(BOOL _finished) {
                self.inViewIndex--;
                self.notAnimating = YES;
            }
        ];
    }
}

- (BOOL)canMoveLeft {
    return self.inViewIndex < [self.streamOfViews count] - 1;
}

- (BOOL)canMoveRight {
    return self.inViewIndex > 0;
}

- (CGFloat)releaseDuration  {
    UIView* viewItem = [self displayedView];
    return abs(viewItem.frame.origin.x) / RELEASE_ANIMATION_SPEED;    
}
 
- (CGFloat)transitionDuration {
    UIView* viewItem = [self displayedView];
    return (self.frame.size.width - abs(viewItem.frame.origin.x)) / TRANSITION_ANIMATION_SPEED;    
}

- (CGRect)inWindow {
    return self.frame;
}

- (CGRect)leftOfWindow {
    return CGRectMake(-self.frame.size.width - VIEW_MIN_SPACING, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGRect)rightOfWindow {
    return CGRectMake(self.frame.size.width + VIEW_MIN_SPACING, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

#pragma mark -
#pragma mark StreamOfViews

+ (id)withFrame:(CGRect)_frame delegate:(id<StreamOfViewsDelegate>)_delegate relativeToView:(UIView*)_relativeView {
    return [[StreamOfViews alloc] initWithFrame:_frame delegate:_delegate relativeToView:(UIView*)_relativeView];
}

- (id)initWithFrame:(CGRect)_frame delegate:(id<StreamOfViewsDelegate>)_delegate relativeToView:(UIView*)_relativeView {
    if ((self = [super initWithFrame:_frame])) {
        self.delegate = _delegate;
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self relativeToView:_relativeView];
        self.streamOfViews = [NSMutableArray arrayWithCapacity:10];
        self.inViewIndex = 0;
        self.notAnimating = YES;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)addView:(UIView*)_view {
    if ([self.streamOfViews count] > 0) {
        UIView* currentView = [self.streamOfViews objectAtIndex:self.inViewIndex];
        currentView.frame = [self rightOfWindow];
    }
    _view.frame = [self inWindow];
    [self addSubview:_view];
    [self.streamOfViews insertObject:_view atIndex:self.inViewIndex];
}

#pragma mark -
#pragma mark TransitionGestureRecognizerDelegate

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragView:_drag];
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    [self dragView:_drag];
}

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didDragUp:from:withVelocity:)]) {
        [self.delegate didDragUp:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didDragDown:from:withVelocity:)]) {
        [self.delegate didDragDown:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didReleaseRight:(CGPoint)_location { 
    [self releaseView];
}

- (void)didReleaseLeft:(CGPoint)_location {
    [self releaseView];
}

- (void)didReleaseUp:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(didReleaseUp:)]) {
        [self.delegate didReleaseUp:_location];
    }
}

- (void)didReleaseDown:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(didReleaseDown:)]) {
        [self.delegate didReleaseDown:_location];
    }
}

- (void)didSwipeRight:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self canMoveRight]) {
        [self moveViewsRight];
    } else {
        [self releaseView];
    }
}

- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self canMoveLeft]) {
        [self moveViewsLeft];
    } else {
        [self releaseView];
    }        
}

- (void)didSwipeUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didSwipeUp:withVelocity:)]) {
        [self.delegate didSwipeUp:_location withVelocity:_velocity];
    }
}

- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didSwipeDown:withVelocity:)]) {
        [self.delegate didSwipeDown:_location withVelocity:_velocity];
    }
}

- (void)didReachMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self canMoveRight]) {
        [self moveViewsRight];
    } else {
        [self releaseView];
    }
}

- (void)didReachMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self canMoveLeft]) {
        [self moveViewsLeft];
    } else {
        [self releaseView];
    }        
}

- (void)didReachMaxDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(didReachMaxDragUp:from:withVelocity:)]) {
        [self.delegate didReachMaxDragUp:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didReachMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(didReachMaxDragDown:from:withVelocity:)]) {
        [self.delegate didReachMaxDragDown:_drag from:_location withVelocity:_velocity];
    }
}


@end
