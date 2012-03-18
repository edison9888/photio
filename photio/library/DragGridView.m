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
- (void)dragRowsUp:(NSValue*)_drag;
- (void)dragRowsDown:(NSValue*)_drag;
- (void)dragRows:(CGPoint)_drag;
- (void)drag:(CGPoint)_drag row:(UIView*)_row;
- (void)releaseRowsUp:(CGPoint)_location;
- (void)releaseRowsDown:(CGPoint)_location;
- (void)swipeRowsUp:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)swipeRowsDown:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)scrollRowsDown:(CGPoint)_velocity;
- (void)scrollRowsUp:(CGPoint)_velocity;
- (CGFloat)offsetDistance;
- (CGFloat)deltaDistance:(CGPoint)_velocity;
- (BOOL)canScrollUp;
- (BOOL)canScrollDown;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DragGridView

@synthesize delegate, transitionGestureRecognizer, rowViews, rowHeight, rowsInView, rowStartView, rowPixelOffset, isScrolling;

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
        [self addSubview:dragRow];
        [self.rowViews addObject:dragRow];
    }
}

- (CGRect)rect:(CGRect)_rect withYOffset:(NSInteger)_offset {
    CGFloat y = _rect.origin.y + _offset * self.rowHeight;
    return CGRectMake(_rect.origin.x, y, _rect.size.width, _rect.size.width);
}

- (void)dragRowsUp:(NSValue*)_drag {
    CGPoint drag = [_drag CGPointValue];
    if ([self canScrollDown]) {
        [self dragRows:drag];
    } else {        
        if ([self.delegate respondsToSelector:@selector(didReachBottom:)]) {
            [self.delegate didReachBottom];
        }
    }
}

- (void)dragRowsDown:(NSValue*)_drag {
    CGPoint drag = [_drag CGPointValue];
    if ([self canScrollUp]) {      
        [self dragRows:drag];
    } else {        
        if ([self.delegate respondsToSelector:@selector(didReachTop:)]) {
            [self.delegate didReachTop];
        }
    }    
}

- (void)dragRows:(CGPoint)_drag {
    for (int i = 0; i < [self.rowViews count]; i++) {
        [self drag:_drag row:[self.rowViews objectAtIndex:i]];
    }
}

- (void)drag:(CGPoint)_drag row:(UIView*)_row {
    CGRect newRect = _row.frame;
    newRect.origin.y += _drag.y;
    _row.frame = newRect;
}

- (void)releaseRowsUp:(CGPoint)_location {
}

- (void)releaseRowsDown:(CGPoint)_location {
}

- (void)swipeRowsUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self scrollRowsUp:_velocity];
}

- (void)scrollRowsUp:(CGPoint)_velocity {
    CGFloat dDistance = -[self deltaDistance:_velocity];
    CGFloat dTime = [self deltaTime:_velocity];
    [self performSelector:@selector(dragRowsUp:) withObject:[NSValue valueWithCGPoint:CGPointMake(0.0, dDistance)] afterDelay:dTime];
}

- (void)swipeRowsDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self scrollRowsDown:_velocity];
}

- (void)scrollRowsDown:(CGPoint)_velocity {
    CGFloat dDistance = [self deltaDistance:_velocity];
    CGFloat dTime = [self deltaTime:_velocity];
    [self performSelector:@selector(dragRowsDown:) withObject:[NSValue valueWithCGPoint:CGPointMake(0.0, dDistance)] afterDelay:dTime];
}

- (CGFloat)deltaDistance:(CGPoint)_velocity {
    CGFloat distance = pow(_velocity.y, 2.0) / ( 2 * DRAG_GRID_ACCELERATION);
    return distance / DRAG_GRID_SWIPE_STEPS;
}

- (CGFloat)deltaTime:(CGPoint)_velocity {
    CGFloat time = fabs(_velocity.y) / DRAG_GRID_ACCELERATION;
    return time / DRAG_GRID_SWIPE_STEPS;
}

- (CGFloat)offsetDistance {
    UIView* firstRow = [self.rowViews objectAtIndex:0];
    return firstRow.frame.origin.y;
}


- (BOOL)canScrollUp {
    BOOL canScroll = YES;
    if ([self offsetDistance] > 0.0) {
        canScroll = NO;
    }
    return canScroll;
}

- (BOOL)canScrollDown {
    BOOL canScroll = YES;
    CGFloat totalViewHeight = self.rowHeight * [self.rowViews count];
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if ((bounds.size.height - [self offsetDistance]) > totalViewHeight) {
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
        self.isScrolling = NO;
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
    [self dragRowsUp:[NSValue valueWithCGPoint:_drag]];
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragRowsDown:[NSValue valueWithCGPoint:_drag]];
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

@end
