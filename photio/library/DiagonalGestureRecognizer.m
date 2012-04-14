//
//  DiagonalGestureRecognizer.m
//  photio
//
//  Created by Troy Stribling on 4/11/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "DiagonalGestureRecognizer.h"

@interface DiagonalGestureRecognizer (PrivateAPI)

@end

@implementation DiagonalGestureRecognizer

@synthesize gestureDelegate, strokeUp, midPoint; 

+ (id)initWithDelegate:(id<DiagonalGestureRecognizerDelegate>)_checkDelegate {
    return [[DiagonalGestureRecognizer alloc] initWithDelegate:_checkDelegate];
}

- (id)initWithDelegate:(id<DiagonalGestureRecognizerDelegate>)_gestureDelegate {
    if (self = [super init]) {
        self.gestureDelegate = _gestureDelegate;
        self.strokeUp = NO;
    }
    return self;
}

- (void)reset {
    [super reset];
    self.midPoint = CGPointZero;
    self.strokeUp = NO;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    if ([touches count] != 1) {
        self.state = UIGestureRecognizerStateFailed;
        return;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prevPoint = [[touches anyObject] previousLocationInView:self.view];
    if (!self.strokeUp) {
        if (nowPoint.x >= prevPoint.x && nowPoint.y >= prevPoint.y) {
            self.midPoint = nowPoint;
        } else if (nowPoint.x >= prevPoint.x && nowPoint.y <= prevPoint.y) {
            strokeUp = YES;
        } else {
            self.state = UIGestureRecognizerStateFailed;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if ((self.state == UIGestureRecognizerStatePossible) && strokeUp) {
        if ([self.gestureDelegate respondsToSelector:@selector(didCheck)]) {
            [self.gestureDelegate didCheck];
        }
        self.state = UIGestureRecognizerStateRecognized;
    }    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.midPoint = CGPointZero;
    self.strokeUp = NO;
    self.state = UIGestureRecognizerStateFailed;
}

@end
