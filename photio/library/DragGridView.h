//
//  DragGridView.h
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"

@protocol DragGridViewDelegate;

@interface DragGridView : UIView <TransitionGestureRecognizerDelegate> {
    __weak id<DragGridViewDelegate> delegate;
    TransitionGestureRecognizer*    transitionGestureRecognizer;
    UIView*                         rowContainerView;
    NSMutableArray*                 rowViews;
    CGFloat                         rowHeight;
    CGFloat                         deltaTime;
    NSInteger                       rowsInView;
    NSInteger                       rowStartView;
    NSInteger                       rowPixelOffset;
    NSInteger                       swipeSteps;
}

@property (nonatomic, weak)     id<DragGridViewDelegate>        delegate;
@property (nonatomic, retain)   TransitionGestureRecognizer*    transitionGestureRecognizer;
@property (nonatomic, retain)   UIView*                         rowContainerView;
@property (nonatomic, retain)   NSMutableArray*                 rowViews;
@property (nonatomic, assign)   CGFloat                         rowHeight;
@property (nonatomic, assign)   CGFloat                         deltaTime;
@property (nonatomic, assign)   NSInteger                       rowsInView;
@property (nonatomic, assign)   NSInteger                       rowStartView;
@property (nonatomic, assign)   NSInteger                       rowPixelOffset;
@property (nonatomic, assign)   NSInteger                       swipeSteps;

+ (id)withFrame:(CGRect)_frame delegate:(id<DragGridViewDelegate>)_delegate rows:(NSMutableArray*)_rows andRelativeView:(UIView*)_relativeView;
- (id)initWithFrame:(CGRect)_frame delegate:(id<DragGridViewDelegate>)_delegate rows:(NSMutableArray*)_rows andRelativeView:(UIView*)_relativeView;

@end

@protocol DragGridViewDelegate <NSObject>

@required

- (NSArray*)needRows;

@optional

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didReleaseRight:(CGPoint)_location;
- (void)didReleaseLeft:(CGPoint)_location;
- (void)didSwipeRight:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity;

- (void)didReachTop;
- (void)didReachBottom;

- (void)didReleaseTop;
- (void)didReleaseBottom;

@end