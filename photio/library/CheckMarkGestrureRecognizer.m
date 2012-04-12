//
//  CheckMarkGestrureRecognizer.m
//  photio
//
//  Created by Troy Stribling on 4/11/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "CheckMarkGestrureRecognizer.h"

@interface CheckMarkGestrureRecognizer (PrivateAPI)

@end

@implementation CheckMarkGestrureRecognizer

@synthesize relativeView, checkDelegate, strokeUp, midPoint; 

+ (id)initWithDelegate:(id<CheckMarkGestrureRecognizerDelegate>)_checkDelegate inView:(UIView*)_view relativeToView:(UIView*)_relativeView {
    return [[CheckMarkGestrureRecognizer alloc] initWithDelegate:_checkDelegate inView:_view relativeToView:_relativeView];
}

- (id)initWithDelegate:(id<CheckMarkGestrureRecognizerDelegate>)_checkDelegate inView:(UIView*)_view relativeToView:(UIView*)_relativeView {
    if (self = [super init]) {
        self.relativeView = _relativeView;
        self.checkDelegate = _checkDelegate;
    }
    return self;
}

- (void)reset {
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
        self.state = UIGestureRecognizerStateRecognized;
    }    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    self.midPoint = CGPointZero;
    strokeUp = NO;
    self.state = UIGestureRecognizerStateFailed;
}

@end
