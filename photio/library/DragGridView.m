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

- (void)initRowParams:(NSArray*)_rows;
- (void)createRows:(NSMutableArray*)_destination from:(NSArray*)_source forCopy:(NSInteger)_copy;
- (void)hideRowIfOffScreen:(UIView*)_row;
- (void)dragRowsLeft:(CGPoint)_drag from:(CGPoint)_location;
- (void)dragRowsRight:(CGPoint)_drag from:(CGPoint)_location;
- (void)dragRow:(CGPoint)_drag;
- (void)drag:(CGPoint)_drag row:(UIView*)_row;
- (void)releaseRowsLeft:(CGPoint)_location;
- (void)releaseRowsRight:(CGPoint)_location;
- (void)moveRowsLeft:(CGPoint)_location;
- (void)moveRowsRight:(CGPoint)_location;
- (CGRect)rowInWindow:(CGRect)_rowFrame;
- (CGRect)rowLeftOfWindow:(CGRect)_rowFrame;
- (CGRect)rowRightOfWindow:(CGRect)_rowFrame;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DragGridView

@synthesize delegate, transitionGestureRecognizer, centerRows, leftRows, rightRows, 
            rowIndexOffset, rowHeight, rowsInView, rowStartView, rowPixelOffset;

#pragma mark -
#pragma mark DragGridView PrivatAPI

- (void)initRows:(NSArray*)_rows {
    [self createRows:self.leftRows from:_rows forCopy:0];
    [self createRows:self.centerRows from:_rows forCopy:1];
    [self createRows:self.rightRows from:_rows forCopy:2];
}

- (void)initRowParams:(NSArray*)_rows {
    UIView* item = [[[_rows objectAtIndex:0] objectAtIndex:0] objectAtIndex:0];
    self.rowHeight = item.frame.size.height;
    self.rowsInView = self.frame.size.height / self.rowHeight;
    self.rowStartView = self.rowIndexOffset;
    self.rowPixelOffset = (self.frame.size.height - self.rowsInView * self.rowHeight) / (self.rowsInView *2);
}

- (void)createRows:(NSMutableArray*)_destination from:(NSArray*)_source forCopy:(NSInteger)_copy {
    for (int i = 0; i < [_source count]; i++) {
        CGRect rowFrame = CGRectMake((_copy - 1) * self.frame.size.width, 
                                     (i - self.rowIndexOffset - (_copy - 1)) * self.rowHeight + self.rowPixelOffset, 
                                     self.frame.size.width, self.rowHeight);
        NSMutableArray* rowForCopy = [NSMutableArray arrayWithCapacity:10]; 
        NSArray* row = [_source objectAtIndex:i];
        for (int j = 0; j < [row count]; j++) {
            NSArray* itemCopies = [row objectAtIndex:j];
            [rowForCopy addObject:[itemCopies objectAtIndex:_copy]];
        }
        DragRowView* dragRow = [DragRowView withFrame:rowFrame andItems:rowForCopy];
        [self hideRowIfOffScreen:dragRow];
        [self addSubview:dragRow];
        [_destination addObject:dragRow];
    }
}

- (void)hideRowIfOffScreen:(UIView*)_row {
    CGRect bounds = [[UIScreen mainScreen] bounds];
    if (_row.frame.origin.y < 0 || _row.frame.origin.y > bounds.size.height) {
        _row.hidden = YES;
    }
}

- (void)dragRowsLeft:(CGPoint)_drag from:(CGPoint)_location {
    NSInteger rowTouched = _location.y / self.rowHeight + 1;
    for (int i = 0; i < rowTouched; i++) {
        [self drag:_drag row:[self.centerRows objectAtIndex:self.rowStartView + i]];
    }
}

- (void)dragRowsRight:(CGPoint)_drag from:(CGPoint)_location {
}

- (void)drag:(CGPoint)_drag row:(UIView*)_row {
    CGRect newRect = _row.frame;
    newRect.origin.x += _drag.x;
    _row.frame = newRect;
}

- (void)releaseRowsLeft:(CGPoint)_location {
    [UIView animateWithDuration:TRANSITION_ANIMATION_DURATION
        delay:0
        options:UIViewAnimationOptionCurveEaseInOut
        animations:^{
            NSInteger rowTouched = _location.y / self.rowHeight + 1;
            for (int i = 0; i < rowTouched; i++) {
                UIView* row = [self.centerRows objectAtIndex:self.rowStartView + i];
                row.frame = [self rowInWindow:row.frame];
            }
        }
        completion:^(BOOL _finished){
        }
    ];
}

- (void)releaseRowsRight:(CGPoint)_location {
}

- (void)moveRowsLeft:(CGPoint)_location {
}

- (void)moveRowsRight:(CGPoint)_location {
}

- (CGRect)rowInWindow:(CGRect)_rowFrame {
    return CGRectMake(0.0, _rowFrame.origin.y, _rowFrame.size.width, _rowFrame.size.height);
}

- (CGRect)rowLeftOfWindow:(CGRect)_rowFrame {
    return CGRectMake(-_rowFrame.size.width, _rowFrame.origin.y, _rowFrame.size.width, _rowFrame.size.height);
}

- (CGRect)rowRightOfWindow:(CGRect)_rowFrame {
    return CGRectMake(_rowFrame.size.width, _rowFrame.origin.y, _rowFrame.size.width, _rowFrame.size.height);
}

#pragma mark -
#pragma mark DragGridView

+ (id)withFrame:(CGRect)_frame delegate:(id<DragGridViewDelegate>)_delegate rows:(NSArray*)_rows andRelativeView:(UIView*)_relativeView {
    return [[DragGridView alloc] initWithFrame:_frame delegate:_delegate rows:_rows relativeView:_relativeView andTopIndexOffset:0];
}

+ (id)withFrame:(CGRect)_frame delegate:(id<DragGridViewDelegate>)_delegate rows:(NSArray*)_rows relativeView:(UIView*)_relativeView andTopIndexOffset:(NSInteger)_indexOffset {
    return [[DragGridView alloc] initWithFrame:_frame delegate:_delegate rows:_rows relativeView:_relativeView andTopIndexOffset:_indexOffset];
}

- (id)initWithFrame:(CGRect)_frame delegate:(id<DragGridViewDelegate>)_delegate rows:(NSArray*)_rows relativeView:(UIView*)_relativeView andTopIndexOffset:(NSInteger)_indexOffset {
    if ((self = [super initWithFrame:_frame])) {
        self.delegate = _delegate;
        self.rowIndexOffset = _indexOffset;
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self relativeToView:_relativeView];
        self.centerRows = [NSMutableArray arrayWithCapacity:10];
        self.leftRows = [NSMutableArray arrayWithCapacity:10];
        self.rightRows = [NSMutableArray arrayWithCapacity:10];
        [self initRowParams:_rows];
        [self initRows:_rows];
    }
    return self;
}

#pragma mark -
#pragma mark TransitionGestureRecognizerDelegate

- (void)didDragRight:(CGPoint)_drag from:(CGPoint)_location {
    [self dragRowsRight:_drag from:(CGPoint)_location];
}

- (void)didDragLeft:(CGPoint)_drag from:(CGPoint)_location{    
    [self dragRowsLeft:_drag from:(CGPoint)_location];
}

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location{
    if ([self.delegate respondsToSelector:@selector(didDragUp:from:)]) {
        [self.delegate didDragUp:_drag from:(CGPoint)_location];
    }
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location{
    if ([self.delegate respondsToSelector:@selector(didDragDown:from:)]) {
        [self.delegate didDragDown:_drag from:(CGPoint)_location];
    }
}

- (void)didReleaseRight:(CGPoint)_location {  
}

- (void)didReleaseLeft:(CGPoint)_location {
    [self releaseRowsLeft:_location];
}

- (void)didReleaseUp:(CGPoint)_location {    
    if ([self.delegate respondsToSelector:@selector(didReleaseUp:)]) {
        [self.delegate didReleaseUp:_location];
    }
}

- (void)didReleaseDown:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(didReleaseDown:)]) {
        [self.delegate didReleaseDown:_location];
    }
}

- (void)didSwipeRight:(CGPoint)_location {
}

- (void)didSwipeLeft:(CGPoint)_location {
}

- (void)didSwipeUp:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(didSwipeUp:)]) {
        [self.delegate didSwipeUp:_location];
    }
}

- (void)didSwipeDown:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(didSwipeDown:)]) {
        [self.delegate didSwipeDown:_location];
    }
}

@end
