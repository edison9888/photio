//
//  StreamOfViews.h
//  photio
//
//  Created by Troy Stribling on 3/25/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"

@protocol StreamOfViewsDelegate;

@interface StreamOfViews : UIView <TransitionGestureRecognizerDelegate> {
    __weak id<StreamOfViewsDelegate> delegate;
    TransitionGestureRecognizer*    transitionGestureRecognizer;
    NSMutableArray*                 streamOfViews;
    NSInteger                       inViewIndex;
}

@property (nonatomic, weak)    id<StreamOfViewsDelegate>       delegate;
@property (nonatomic, retain)  TransitionGestureRecognizer*    transitionGestureRecognizer;
@property (nonatomic, retain)  NSMutableArray*                 streamOfViews;
@property (nonatomic, assign)  NSInteger                       inViewIndex;

+ (id)withFrame:(CGRect)_frame delegate:(id<StreamOfViewsDelegate>)_delegate;
- (id)initWithFrame:(CGRect)_frame delegate:(id<StreamOfViewsDelegate>)_delegate;
- (void)addView:(UIView*)_view;

@end

@protocol StreamOfViewsDelegate <NSObject>

@optional

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didReleaseUp:(CGPoint)_location;
- (void)didReleaseDown:(CGPoint)_location;
- (void)didSwipeUp:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didReachMaxDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didReachMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;

@end
