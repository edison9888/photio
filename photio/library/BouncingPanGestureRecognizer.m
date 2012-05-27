//
//  BouncingPanGestureRecognizer.m
//  photio
//
//  Created by Troy Stribling on 5/26/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "BouncingPanGestureRecognizer.h"

#define BOUNCE_FACTOR                   0.1
#define BOUNCE_ANIMATION_DURATION       0.5

@interface BouncingPanGestureRecognizer (PrivateAPI)

- (void)touched:(UIPanGestureRecognizer*)_panGesture;
- (void)animateViewToXPos:(CGFloat)_xpos;

@end

@implementation BouncingPanGestureRecognizer

@synthesize contentView, relativeView, panGestureRecognizer, contentViewFrame, minXOffset, bounce;

#pragma mark -
#pragma mark BouncingPanGestureRecognizer PrivateAPI

- (void)touched:(UIPanGestureRecognizer*)_panGesture {
    CGPoint dragDelta = [_panGesture translationInView:self.relativeView];
    CGFloat newXOffset = self.contentViewFrame.origin.x + dragDelta.x;
    if (newXOffset < self.minXOffset - self.bounce) {
        newXOffset = self.minXOffset - self.bounce;
    } else if (newXOffset > self.bounce) {
        newXOffset = self.bounce;
    }
    switch (_panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            self.contentView.frame = CGRectMake(newXOffset, self.contentViewFrame.origin.y, self.contentViewFrame.size.width, self.contentViewFrame.size.height);
            break;
        case UIGestureRecognizerStateEnded:
            if (newXOffset < self.minXOffset) {
                [self animateViewToXPos:self.minXOffset];
            } else if (newXOffset > 0.0) {
                [self animateViewToXPos:0.0];
            }
            self.contentViewFrame = self.contentView.frame;
            break;
        default:
            break;
    }
}

- (void)animateViewToXPos:(CGFloat)_xpos {
    self.contentViewFrame = CGRectMake(_xpos, self.contentView.frame.origin.y, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [UIView animateWithDuration:BOUNCE_ANIMATION_DURATION 
        delay:0.0 
        options:UIViewAnimationCurveEaseOut
         animations:^{
             self.contentView.frame = self.contentViewFrame;
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
        self.contentView = _view;
        self.contentViewFrame = self.contentView.frame;
        self.relativeView = _relativeView;
        self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touched:)];
        [self.contentView addGestureRecognizer:self.panGestureRecognizer];
        self.minXOffset = self.relativeView.frame.size.width - self.contentView.frame.size.width;
        self.bounce = self.contentView.frame.size.width * BOUNCE_FACTOR;
    }
    return self;
}


@end
