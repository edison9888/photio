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

- (void)dragViews:(CGPoint)_drag;
- (void)moveViewsLeft;
- (void)moveViewsRight;
- (BOOL)canMoveLeft;
- (BOOL)canMoveRight;

@end

@implementation StreamOfViews

@synthesize delegate, transitionGestureRecognizer, streamOfViews, inViewIndex;

#pragma mark -
#pragma mark StreamOfViews PrivatAPI

#pragma mark -
#pragma mark StreamOfViews

+ (id)withFrame:(CGRect)_frame delegate:(id<StreamOfViewsDelegate>)_delegate relativeView:(UIView*)_relativeView {
    return [[StreamOfViews alloc] initWithFrame:_frame delegate:_delegate relativeView:_relativeView];
}

- (id)initWithFrame:(CGRect)_frame delegate:(id<StreamOfViewsDelegate>)_delegate relativeView:(UIView*)_relativeView {
    if ((self = [super initWithFrame:_frame])) {
        self.delegate = _delegate;
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self relativeToView:_relativeView];
        self.streamOfViews = [NSMutableArray arrayWithCapacity:10];
        self.inViewIndex = 0;
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

- (void)addView:(UIView*)_view {
    NSInteger viewCount = [self.streamOfViews count] + 1;
    self.frame = CGRectMake(0.0, 0.0, viewCount * self.frame.size.width, self.frame.size.height);
    _view.frame = CGRectMake((viewCount - 1) * _view.frame.size.width, 0.0, _view.frame.size.width, _view.frame.size.height);
    [self addSubview:_view];
    [self.streamOfViews addObject:_view];
}

- (void)dragViews:(CGPoint)_drag {
    self.transform = CGAffineTransformTranslate(self.transform, _drag.x, _drag.y);
}

- (void)moveViewsLeft {
}

- (void)moveViewsRight {
}

- (BOOL)canMoveLeft {
    return self.inViewIndex < [self.streamOfViews count];
}

- (BOOL)canMoveRight {
    return self.inViewIndex > 0;
}

#pragma mark -
#pragma mark TransitionGestureRecognizerDelegate

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragViews:_drag];
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    [self dragViews:_drag];
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
}

- (void)didReleaseLeft:(CGPoint)_location {
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
