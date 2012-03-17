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
- (void)hideRowIfOffScreen:(UIView*)_row;
- (void)showRowIfOnScreen:(UIView*)_row withYOffSet:(NSInteger)_offset;
- (CGRect)rect:(CGRect)_rect withYOffset:(NSInteger)_offset;
- (void)dragRowsUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)dragRowsDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity;
- (void)dragRow:(CGPoint)_drag;
- (void)drag:(CGPoint)_drag row:(UIView*)_row;
- (void)releaseRowsLeft:(CGPoint)_location;
- (void)releaseRowsRight:(CGPoint)_location;
- (void)swipeRowsLeft:(CGPoint)_location;
- (void)swipeRowsRight:(CGPoint)_location;
- (CGRect)rowInWindow:(CGRect)_rowFrame;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DragGridView

@synthesize delegate, transitionGestureRecognizer, rowViews, rowHeight, rowsInView, rowStartView, rowPixelOffset;

#pragma mark -
#pragma mark DragGridView PrivatAPI

- (void)initRowParams:(NSMutableArray*)_rows {
    UIView* item = [[_rows objectAtIndex:0] objectAtIndex:0];
    self.rowHeight = item.frame.size.height;
    self.rowsInView = self.frame.size.height / self.rowHeight;
    self.rowPixelOffset = (self.frame.size.height - self.rowsInView * self.rowHeight) / (self.rowsInView *2);
}

- (void)createRows:(NSMutableArray*)_rows {
    for (int i = 0; i < [_rows count]; i++) {
        CGRect rowFrame = CGRectMake(0.0, i  * self.rowHeight + self.rowPixelOffset, self.frame.size.width, self.rowHeight);
        NSArray* row = [_rows objectAtIndex:i];
        DragRowView* dragRow = [DragRowView withFrame:rowFrame andItems:row];
        [self hideRowIfOffScreen:dragRow];
        [self addSubview:dragRow];
        [self.rowViews addObject:dragRow];
    }
}

- (void)hideRowIfOffScreen:(UIView*)_row {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if (_row.frame.origin.y < 0 || _row.frame.origin.y > bounds.size.height || _row.frame.origin.x < 0 || _row.frame.origin.x > bounds.size.width) {
        _row.hidden = YES;
    }
}

- (void)showRowIfOnScreen:(UIView*)_row withYOffSet:(NSInteger)_offset {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGRect offsetRect = [self rect:_row.frame withYOffset:_offset];
    if (offsetRect.origin.x >= 0.0f && offsetRect.origin.x <= bounds.size.width && offsetRect.origin.y >= 0.0f && offsetRect.origin.y <= bounds.size.height) {
        _row.hidden = NO;
    }
}

- (CGRect)rect:(CGRect)_rect withYOffset:(NSInteger)_offset {
    CGFloat y = _rect.origin.y + _offset * self.rowHeight;
    return CGRectMake(_rect.origin.x, y, _rect.size.width, _rect.size.width);
}

- (void)dragRowsUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    
}

- (void)dragRowsDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    
}

- (void)dragRows:(CGPoint)_drag from:(CGPoint)_location {
    for (int i = 0; i < [self.rowViews count]; i++) {
        [self drag:_drag row:[self.rowViews objectAtIndex:i]];
    }
}

- (void)drag:(CGPoint)_drag row:(UIView*)_row {
    CGRect newRect = _row.frame;
    newRect.origin.x += _drag.x;
    _row.frame = newRect;
}

- (void)releaseRowsUp:(CGPoint)_location {
}

- (void)releaseRowsDown:(CGPoint)_location {
}

- (void)swipeRowsLeft:(CGPoint)_location {
}

- (void)swipeRowsRight:(CGPoint)_location {
}

- (CGRect)rowInWindow:(CGRect)_rowFrame {
    return CGRectMake(0.0, _rowFrame.origin.y, _rowFrame.size.width, _rowFrame.size.height);
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
        [self initRowParams:_rows];
        [self createRows:_rows];
    }
    return self;
}

#pragma mark -
#pragma mark TransitionGestureRecognizerDelegate

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(didDragRight:from:withVelocity:)]) {
        [self.delegate didDragRight:_drag from:(CGPoint)_location withVelocity:_velocity];
    }
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(didDragLeft:from:withVelocity:)]) {
        [self.delegate didDragLeft:_drag from:(CGPoint)_location withVelocity:_velocity];
    }
}

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragRowsUp:_drag from:(CGPoint)_location withVelocity:_velocity];
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    [self dragRowsDown:_drag from:(CGPoint)_location withVelocity:_velocity];
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
    [self releaseRowsLeft:_location];
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
}

- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

@end
