//
//  BouncingPanGestureRecognizer.m
//  photio
//
//  Created by Troy Stribling on 5/26/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "BouncingPanGestureRecognizer.h"

#define BOUNCE_FACTOR               0.1
#define BOUNCE_ANIMATION_DURATION   0.5

@interface BouncingPanGestureRecognizer (PrivateAPI)

- (void)touched:(UIPanGestureRecognizer*)_panGesture;
- (void)animateViewToXPos:(CGFloat)_xpos;

@end

@implementation BouncingPanGestureRecognizer

@synthesize view, relativeView, panGestureRecognizer, viewFrame;

#pragma mark -
#pragma mark BouncingPanGestureRecognizer PrivateAPI

- (void)touched:(UIPanGestureRecognizer*)_panGesture {
    CGPoint velocity = [_panGesture velocityInView:self.relativeView];
    CGPoint dragDelta = [_panGesture translationInView:self.relativeView];
    CGFloat newXOffset = self.viewFrame.origin.x + dragDelta.x;
    CGFloat minOffset = self.relativeView.frame.size.width - self.view.frame.size.width;
    CGFloat bounce = self.view.frame.size.width * BOUNCE_FACTOR;
    if (newXOffset < minOffset - bounce) {
        newXOffset = minOffset - bounce;
    } else if (newXOffset > bounce) {
        newXOffset = bounce;
    }
    switch (_panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            self.view.frame = CGRectMake(newXOffset, self.viewFrame.origin.y, self.viewFrame.size.width, self.viewFrame.size.height);
            break;
        case UIGestureRecognizerStateEnded:
            if (newXOffset < minOffset) {
                [self animateViewToXPos:minOffset];
            } else if (newXOffset > 0.0) {
                [self animateViewToXPos:0.0];
            }
            self.viewFrame = self.view.frame;
            break;
        default:
            break;
    }
}

- (void)animateViewToXPos:(CGFloat)_xpos {
    self.viewFrame = CGRectMake(_xpos, self.view.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height);
    [UIView animateWithDuration:BOUNCE_ANIMATION_DURATION 
        delay:0.0 
        options:UIViewAnimationCurveEaseOut
         animations:^{
             self.view.frame = self.viewFrame;
         }
         completion:^(BOOL _finiahed) {
         }
     ];
}

#pragma mark -
#pragma mark BouncingPanGestureRecognizer

+ (id)inView:(UIView*)_view relativeToView:(UIView*)_relativeView {
    return [[BouncingPanGestureRecognizer alloc] initInView:_view relativeToView:_relativeView];
}

- (id)initInView:(UIView*)_view relativeToView:(UIView*)_relativeView {
    if (self = [super init]) {
        self.view = _view;
        self.viewFrame = self.view.frame;
        self.relativeView = _relativeView;
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
        [self.view addGestureRecognizer:self.panGestureRecognizer];
    }
    return self;
}


@end
