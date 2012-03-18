//
//  DragGridView.m
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "DragGridView.h"
#import "DragRowView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DragGridView (PrivateAPI)

- (void)initRowParams:(NSMutableArray*)_rows;
- (void)createRows:(NSMutableArray*)_rows;
- (CGRect)rect:(CGRect)_rect withYOffset:(NSInteger)_offset;

- (void)dragRowsUp:(CGPoint)_drag;
- (void)dragRowsDown:(CGPoint)_drag;
- (void)dragRows:(CGPoint)_drag;
- (void)drag:(CGPoint)_drag row:(UIView*)_row;

- (void)releaseRowsUp:(CGPoint)_location;
- (void)releaseRowsDown:(CGPoint)_location;

- (void)swipeRowsUp:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)scrollRowsUp:(NSValue*)_velocityValue;
- (void)swipeRowsDown:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)scrollRowsDown:(NSValue*)_params;
- (void)startScroll:(CGPoint)_velocityValue;

- (CGPoint)nextDragWithVelocity:(CGPoint)_velocity andAcceleration:(CGFloat)_acceleration;
- (CGPoint)nextVelocity:(CGPoint)_velocity withAcceleration:(CGFloat)_acceleration;
- (CGFloat)accelerationWithVelocity:(CGPoint)_velocity;

- (BOOL)canScrollUp;
- (BOOL)canScrollDown;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DragGridView

@synthesize delegate, transitionGestureRecognizer, rowViews, rowHeight, rowsInView, rowStartView, rowPixelOffset, swipeSteps, 
            rowContainerView, deltaTime;

#pragma mark -
#pragma mark DragGridView PrivatAPI

- (void)initRowParams:(NSMutableArray*)_rows {
    UIView* item = [[_rows objectAtIndex:0] objectAtIndex:0];
    self.rowHeight = item.frame.size.height;
    self.rowsInView = self.frame.size.height / self.rowHeight;
    self.rowPixelOffset = (self.frame.size.height - self.rowsInView * self.rowHeight) / (self.rowsInView *2);
}

- (void)createRows:(NSMutableArray*)_rows {
    self.rowViews = [NSMutableArray arrayWithCapacity:[_rows count]];
    for (int i = 0; i < [_rows count]; i++) {
        CGRect rowFrame = CGRectMake(0.0, i  * self.rowHeight + self.rowPixelOffset, self.frame.size.width, self.rowHeight);
        NSArray* row = [_rows objectAtIndex:i];
        DragRowView* dragRow = [DragRowView withFrame:rowFrame andItems:row];
        [self.rowContainerView addSubview:dragRow];
        [self.rowViews addObject:dragRow];
    }
}

- (CGRect)rect:(CGRect)_rect withYOffset:(NSInteger)_offset {
    CGFloat y = _rect.origin.y + _offset * self.rowHeight;
    return CGRectMake(_rect.origin.x, y, _rect.size.width, _rect.size.width);
}

- (void)dragRowsUp:(CGPoint)_drag {
    if ([self canScrollDown]) {
        [self dragRows:_drag];
    } else {        
        if ([self.delegate respondsToSelector:@selector(didReachBottom:)]) {
            [self.delegate didReachBottom];
        }
    }
}

- (void)dragRowsDown:(CGPoint)_drag {
    if ([self canScrollUp]) {      
        [self dragRows:_drag];
    } else {        
        if ([self.delegate respondsToSelector:@selector(didReachTop:)]) {
            [self.delegate didReachTop];
        }
    }    
}

- (void)dragRows:(CGPoint)_drag {
    self.rowContainerView.transform = CGAffineTransformTranslate(self.rowContainerView.transform, 0.0, _drag.y);
}

- (void)releaseRowsUp:(CGPoint)_location {
}

- (void)releaseRowsDown:(CGPoint)_location {
}

- (void)swipeRowsUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self startScroll:_velocity];
    [self scrollRowsUp:[NSValue valueWithCGPoint:_velocity]];
}

- (void)scrollRowsUp:(NSValue*)_velocityValue {
    CGPoint velocity = [_velocityValue CGPointValue];
    CGFloat acceleration = [self accelerationWithVelocity:velocity];
    CGPoint drag = [self nextDragWithVelocity:velocity andAcceleration:acceleration];
    [self dragRowsUp:drag];
    velocity = [self nextVelocity:velocity withAcceleration:acceleration];
    if (self.swipeSteps < DRAG_GRID_SWIPE_STEPS) {
        [self performSelector:@selector(scrollRowsUp:) withObject:[NSValue valueWithCGPoint:velocity] afterDelay:self.deltaTime];
    }
    self.swipeSteps++;
}

- (void)swipeRowsDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self startScroll:_velocity];
    [self scrollRowsDown:[NSValue valueWithCGPoint:_velocity]];
}

- (void)scrollRowsDown:(NSValue*)_velocityValue {
    CGPoint velocity = [_velocityValue CGPointValue];
    CGFloat acceleration = [self accelerationWithVelocity:velocity];
    CGPoint drag = [self nextDragWithVelocity:velocity andAcceleration:acceleration];
    [self dragRowsDown:drag];
    velocity = [self nextVelocity:velocity withAcceleration:acceleration];
    if (self.swipeSteps < DRAG_GRID_SWIPE_STEPS) {
        [self performSelector:@selector(scrollRowsDown:) withObject:[NSValue valueWithCGPoint:velocity] afterDelay:self.deltaTime];
    }
    self.swipeSteps++;
}

- (void)startScroll:(CGPoint)_velocity {
    CGFloat time = logb(fabs(_velocity.y) / DRAG_GRID_MIN_VELOCITY) / DRAG_GRID_ACCELERATION;
    self.deltaTime =  time / DRAG_GRID_SWIPE_STEPS;
    self.swipeSteps = 0;
}

- (CGPoint)nextDragWithVelocity:(CGPoint)_velocity andAcceleration:(CGFloat)_acceleration {
    CGFloat drag = _velocity.y * self.deltaTime + 0.5 * _acceleration * pow(self.deltaTime, 2.0);
    return CGPointMake(0.0, drag);
}

- (CGPoint)nextVelocity:(CGPoint)_velocity withAcceleration:(CGFloat)_acceleration {
    CGFloat vel = _velocity.y + _acceleration * self.deltaTime;
    return CGPointMake(_velocity.x, vel);
}

- (CGFloat)accelerationWithVelocity:(CGPoint)_velocity {
    CGFloat acc = -_velocity.y * DRAG_GRID_ACCELERATION;
    return acc;
}

- (BOOL)canScrollUp {
    BOOL canScroll = YES;
    if (self.rowContainerView.frame.origin.y > 0.0) {
        canScroll = NO;
    }
    return canScroll;
}

- (BOOL)canScrollDown {
    BOOL canScroll = YES;
    CGFloat totalViewHeight = self.rowHeight * [self.rowViews count];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ((bounds.size.height - self.rowContainerView.frame.origin.y) > totalViewHeight) {
        canScroll = NO;
    }
    return canScroll;    
}


#pragma mark -
#pragma mark DragGridView

+ (id)withFrame:(CGRect)_frame delegate:(id<DragGridViewDelegate>)_delegate rows:(NSMutableArray*)_rows andRelativeView:(UIView*)_relativeView {
    return [[DragGridView alloc] initWithFrame:_frame delegate:_delegate rows:_rows andRelativeView:_relativeView];
}

- (id)initWithFrame:(CGRect)_frame delegate:(id<DragGridViewDelegate>)_delegate rows:(NSMutableArray*)_rows andRelativeView:(UIView*)_relativeView {
    if ((self = [super initWithFrame:_frame])) {
        self.delegate = _delegate;
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self relativeToView:_relativeView];
        self.rowContainerView = [[UIView alloc] initWithFrame:_frame];
        [self addSubview:self.rowContainerView];
        [self initRowParams:_rows];
        [self createRows:_rows];
    }
    return self;
}

#pragma mark -
#pragma mark TransitionGestureRecognizerDelegate

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didDragRight:from:withVelocity:)]) {
        [self.delegate didDragRight:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(didDragLeft:from:withVelocity:)]) {
        [self.delegate didDragLeft:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragRowsUp:_drag];
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragRowsDown:_drag];
}

- (void)didReleaseRight:(CGPoint)_location {  
    if ([self.delegate respondsToSelector:@selector(didReleaseRight:)]) {
        [self.delegate didReleaseRight:_location];
    }
}

- (void)didReleaseLeft:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(didReleaseLeft:)]) {
        [self.delegate didReleaseLeft:_location];
    }
}

- (void)didReleaseUp:(CGPoint)_location {    
}

- (void)didReleaseDown:(CGPoint)_location {
}

- (void)didSwipeRight:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didSwipeRight:withVelocity:)]) {
        [self.delegate didSwipeRight:_location withVelocity:_velocity];
    }
}

- (void)didSwipeLeft:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didSwipeLeft:withVelocity:)]) {
        [self.delegate didSwipeLeft:_location withVelocity:_velocity];
    }
}

- (void)didSwipeUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self swipeRowsUp:_location withVelocity:_velocity];
}

- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self swipeRowsDown:_location withVelocity:_velocity];
}

- (void)didReachMaxDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didReachMaxDragRight: from:withVelocity:)]) {
        [self.delegate didReachMaxDragRight:_drag from:_location withVelocity:_velocity];
    }    
}

- (void)didReachMaxDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didReachMaxDragLeft: from:withVelocity:)]) {
        [self.delegate didReachMaxDragLeft:_drag from:_location withVelocity:_velocity];
    }
}

- (void)didReachMaxDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragRowsUp:_drag];
}

- (void)didReachMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragRowsDown:_drag];
}


@end
