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
- (void)createRows:(NSMutableArray*)_destination from:(NSArray*)_source start:(NSInteger)_start end:(NSInteger)_end copy:(NSInteger)_copy;
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

@synthesize delegate, transitionGestureRecognizer, centerRows, leftRows, rightRows, indexOffset, rowHeight, rowOffset;

#pragma mark -
#pragma mark DragGridView PrivatAPI

- (void)initRows:(NSArray*)_rows {
    [self createRows:self.leftRows from:_rows start:0 end:[_rows count] - 2 * self.indexOffset copy:0];
    [self createRows:self.centerRows from:_rows start:self.indexOffset end:[_rows count] - self.indexOffset copy:1];
    [self createRows:self.rightRows from:_rows start:2 * self.indexOffset end:[_rows count] copy:2];
}

- (void)initRowParams:(NSArray*)_rows {
    UIView* item = [[[_rows objectAtIndex:0] objectAtIndex:0] objectAtIndex:0];
    self.rowHeight = item.frame.size.height;
    self.rowOffset = (self.frame.size.height - ([_rows count] - self.indexOffset) * self.rowHeight / 2);
}

- (void)createRows:(NSMutableArray*)_destination from:(NSArray*)_source start:(NSInteger)_start end:(NSInteger)_end copy:(NSInteger)_copy {
    for (int i = _start; i < _end; i++) {
        CGRect rowFrame = CGRectMake(0.0, (i - _start) * self.rowHeight + self.rowOffset, self.frame.size.width, self.rowHeight);
        [_destination addObject:[DragRowView withFrame:rowFrame andItems:[[_source objectAtIndex:i] objectAtIndex:_copy]]];
    }
}

- (void)dragRows:(CGPoint)_drag {
    for (int i = 0; i < [self.centerRows count]; i++) {
        [self drag:_drag row:[self.leftRows objectAtIndex:i]];
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

+ (id)withFrame:(CGRect)_rect andRows:(NSArray*)_rows {
    return [[DragGridView alloc] initWithFrame:_rect rows:_rows andIndexOffset:0];
}

+ (id)withFrame:(CGRect)_rect rows:(NSArray*)_rows andIndexOffset:(NSInteger)_indexOffset {
    return [[DragGridView alloc] initWithFrame:_rect rows:_rows andIndexOffset:_indexOffset];
}

- (id)initWithFrame:(CGRect)_frame rows:(NSArray*)_rows andIndexOffset:(NSInteger)_indexOffset {
    if ((self = [super initWithFrame:_frame])) {
        self.indexOffset = _indexOffset;
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

- (void)didReleaseRight {    
}

- (void)didReleaseLeft {
}

- (void)didSwipeRight {
}

- (void)didSwipeLeft {
}

@end
