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
- (void)dragRows:(CGPoint)_drag;
- (void)dragRow:(CGPoint)_drag;
- (void)drag:(CGPoint)_drag row:(UIView*)_row;
- (void)releaseRowsLeft;
- (void)releaseRowsRight;
- (void)moveRowsLeft;
- (void)moveRowsRight;

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
        CGRect rowFrame = CGRectMake((_copy - 1) * self.frame.size.width, (i - self.rowIndexOffset) * self.rowHeight + self.rowPixelOffset, self.frame.size.width, self.rowHeight);
        NSMutableArray* rowForCopy = [NSMutableArray arrayWithCapacity:10];
        NSArray* row = [_source objectAtIndex:i];
        for (int j = 0; j < [row count]; j++) {
            NSArray* itemCopies = [row objectAtIndex:j];
            [rowForCopy addObject:[itemCopies objectAtIndex:_copy]];
        }
        DragRowView* dragRow = [DragRowView withFrame:rowFrame andItems:[[_source objectAtIndex:i] objectAtIndex:_copy]];
        [self addSubview:dragRow];
        [_destination addObject:dragRow];
    }
}

- (void)dragRows:(CGPoint)_drag {
    for (int i = 0; i < [self.centerRows count]; i++) {
        [self drag:_drag row:[self.leftRows objectAtIndex:(self.rowIndexOffset + 1)]];
        [self drag:_drag row:[self.centerRows objectAtIndex:i]];
        [self drag:_drag row:[self.rightRows objectAtIndex:i]];
    }
}

- (void)drag:(CGPoint)_drag row:(UIView*)_row {
    CGRect newRect = _row.frame;
    newRect.origin.x += _drag.x;
    _row.frame = newRect;
}

- (void)releaseRowsLeft {
}

- (void)releaseRowsRight {
}

- (void)moveRowsLeft {
}

- (void)moveRowsRight {
}

#pragma mark -
#pragma mark DragGridView

+ (id)withFrame:(CGRect)_rect delegate:(id<DragGridViewDelegate>)_delegate andRows:(NSArray*)_rows {
    return [[DragGridView alloc] initWithFrame:_rect delegate:_delegate rows:_rows andTopIndexOffset:0];
}

+ (id)withFrame:(CGRect)_rect delegate:(id<DragGridViewDelegate>)_delegate rows:(NSArray*)_rows andTopIndexOffset:(NSInteger)_indexOffset {
    return [[DragGridView alloc] initWithFrame:_rect delegate:_delegate rows:_rows andTopIndexOffset:_indexOffset];
}

- (id)initWithFrame:(CGRect)_frame delegate:(id<DragGridViewDelegate>)_delegate rows:(NSArray*)_rows andTopIndexOffset:(NSInteger)_indexOffset {
    if ((self = [super initWithFrame:_frame])) {
        self.delegate = _delegate;
        self.rowIndexOffset = _indexOffset;
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self relativeToView:self];
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

- (void)didDragRight:(CGPoint)_drag {
}

- (void)didDragLeft:(CGPoint)_drag {    
}

- (void)didDragUp:(CGPoint)_drag {
    if ([self.delegate respondsToSelector:@selector(didDragUp:)]) {
        [self.delegate didDragUp:_drag];
    }
}

- (void)didDragDown:(CGPoint)_drag {
    if ([self.delegate respondsToSelector:@selector(didDragDown:)]) {
        [self.delegate didDragDown:_drag];
    }
}

- (void)didReleaseRight {    
}

- (void)didReleaseLeft {
}

- (void)didReleaseUp {    
    if ([self.delegate respondsToSelector:@selector(didReleaseUp)]) {
        [self.delegate didReleaseUp];
    }
}

- (void)didReleaseDown {
    if ([self.delegate respondsToSelector:@selector(didReleaseDown)]) {
        [self.delegate didReleaseDown];
    }
}

- (void)didSwipeRight {
}

- (void)didSwipeLeft {
}

- (void)didSwipeUp {
    if ([self.delegate respondsToSelector:@selector(didSwipeUp)]) {
        [self.delegate didSwipeUp];
    }
}

- (void)didSwipeDown {
    if ([self.delegate respondsToSelector:@selector(didSwipeDown)]) {
        [self.delegate didSwipeDown];
    }
}

@end
