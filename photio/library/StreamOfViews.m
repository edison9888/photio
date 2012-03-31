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

@end

@implementation StreamOfViews

@synthesize delegate, transitionGestureRecognizer, streamOfViews, inViewIndex;

#pragma mark -
#pragma mark StreamOfViews PrivatAPI

- (UIView*)displayedView {
    return [self.streamOfViews objectAtIndex:self.inViewIndex];
}

- (void)dragView:(CGPoint)_drag {
    UIView* viewItem = [self displayedView];
    viewItem.transform = CGAffineTransformTranslate(viewItem.transform, _drag.x, _drag.y);
}

- (void)releaseView {
    [UIView animateWithDuration:[self releaseDuration]
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionFlipFromLeft
        animations:^{
            [self displayedView].frame = [self inWindow];
        }
        completion:^(BOOL _finished){
        }
     ];
 }

- (void)moveViewsLeft {
    if ([self canMoveLeft]) {
        [UIView animateWithDuration:[self transitionDuration]
            delay:0
            options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionFlipFromLeft
            animations:^{
            }
            completion:^(BOOL _finished) {
                self.inViewIndex++;
            }
         ];
    }
}

- (void)moveViewsRight {
    if ([self canMoveRight]) {
        [UIView animateWithDuration:[self transitionDuration]
            delay:0
            options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionTransitionFlipFromLeft
            animations:^{
            }
            completion:^(BOOL _finished) {
                self.inViewIndex--;
            }
        ];
    }
}

- (BOOL)canMoveLeft {
    return self.inViewIndex < [self.streamOfViews count];
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
    CGRect bounds = self.frame;
    return CGRectMake(-bounds.size.width, bounds.origin.y, bounds.size.width, bounds.size.height);
}

- (CGRect)rightOfWindow {
    CGRect bounds = self.frame;
    return CGRectMake(bounds.size.width, bounds.origin.y, bounds.size.width, bounds.size.height);
}

#pragma mark -
#pragma mark StreamOfViews

+ (id)withFrame:(CGRect)_frame delegate:(id<StreamOfViewsDelegate>)_delegate {
    return [[StreamOfViews alloc] initWithFrame:_frame delegate:_delegate];
}

- (id)initWithFrame:(CGRect)_frame delegate:(id<StreamOfViewsDelegate>)_delegate {
    if ((self = [super initWithFrame:_frame])) {
        self.delegate = _delegate;
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self relativeToView:self];
        self.streamOfViews = [NSMutableArray arrayWithCapacity:10];
        self.inViewIndex = 0;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)addView:(UIView*)_view {
    _view.frame = CGRectMake([self.streamOfViews count] * _view.frame.size.width, 0.0, _view.frame.size.width, _view.frame.size.height);
    [self addSubview:_view];
    [self.streamOfViews addObject:_view];
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
}

- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity {
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
}

- (void)didReachMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
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
