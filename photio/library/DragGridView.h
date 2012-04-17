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

@interface DragGridView : UIView <TransitionGestureRecognizerDelegate, UIScrollViewDelegate> {
}

@property(nonatomic, weak)     id<DragGridViewDelegate>        delegate;
@property(nonatomic, strong)   TransitionGestureRecognizer*    transitionGestureRecognizer;
@property(nonatomic, strong)   UIScrollView*                   rowContainerView;
@property(nonatomic, strong)   NSMutableArray*                 rowViews;
@property(nonatomic, assign)   CGFloat                         rowHeight;
@property(nonatomic, assign)   CGFloat                         deltaTime;
@property(nonatomic, assign)   NSInteger                       rowsInView;
@property(nonatomic, assign)   NSInteger                       rowStartView;
@property(nonatomic, assign)   NSInteger                       rowPixelOffset;
@property(nonatomic, assign)   NSInteger                       scrollSteps;
@property(nonatomic, assign)   NSInteger                       topRow;  
@property(nonatomic, assign)   NSInteger                       rowBuffer;
@property(nonatomic, assign)   NSInteger                       viewYOffset;
@property (nonatomic, assign)  BOOL                            inAnimation;

+ (id)withFrame:(CGRect)_frame delegate:(id<DragGridViewDelegate>)_delegate rows:(NSMutableArray*)_rows andRelativeView:(UIView*)_relativeView;
- (id)initWithFrame:(CGRect)_frame delegate:(id<DragGridViewDelegate>)_delegate rows:(NSMutableArray*)_rows andRelativeView:(UIView*)_relativeView;

@end

@protocol DragGridViewDelegate <NSObject>

@required

- (NSArray*)needBottomRows;
- (NSArray*)needTopRows;

@optional

- (void)removedTopRow:(NSArray*)_row;
- (void)removedBottomRow:(NSArray*)_row;

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didReleaseRight:(CGPoint)_location;
- (void)didReleaseLeft:(CGPoint)_location;
- (void)didSwipeRight:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didReachMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)didReachMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;

- (void)didReachTop;
- (void)didReachBottom;

- (void)didReleaseTop;
- (void)didReleaseBottom;

@end