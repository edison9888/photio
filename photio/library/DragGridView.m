//
//  DragGridView.m
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "DragGridView.h"
#import "DragRowView.h"

#define DETECT_DRAG_BOUNCE      20.0
#define BOUNCE_OFFSET           75.0
#define BOUNCE_DURATION         0.25
#define BOUNCE_DELAY            0.25
#define SCROLL_UP_DURATION      1.0

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DragGridView (PrivateAPI)

- (void)initRowParams:(NSMutableArray*)_rows;
- (void)setContentSize;
- (void)buildLoadingView;
- (NSMutableArray*)createRows:(NSArray*)_rows withOffSet:(NSInteger)_offset;
- (DragRowView*)createRow:(NSArray*)_row atIndex:(NSInteger)_rowIndex withOffSet:(NSInteger)_offset;
- (CGRect)rect:(CGRect)_rect withYOffset:(NSInteger)_offset;
- (void)addTopRows:(NSArray*)_rows;
- (void)addBottomRows:(NSArray *)_rows;
- (void)removeTopRows:(NSInteger)_rows;
- (void)removeBottomRows:(NSInteger)_rows;
- (void)bounceViewUp;
- (void)bounceViewDown;
- (void)scrollViewUp;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DragGridView

@synthesize delegate, transitionGestureRecognizer, rowViews, rowHeight, rowsInView, rowPixelOffset,
            rowContainerView, loadingView, loadingSpinnerView, deltaTime, topRow, rowBuffer, bouncing;

#pragma mark -
#pragma mark DragGridView PrivatAPI

- (void)initRowParams:(NSMutableArray*)_rows {
    if ([_rows count] > 0) {
        UIView* item = [[_rows objectAtIndex:0] objectAtIndex:0];
        self.rowHeight = item.frame.size.height;
        self.rowsInView = self.frame.size.height / self.rowHeight;
        self.rowPixelOffset = (self.frame.size.height - self.rowsInView * self.rowHeight) / (self.rowsInView * 2);
        self.topRow = 0;
    }
}

- (void)setContentSize {
    self.rowContainerView.contentSize = CGSizeMake(self.frame.size.width, self.rowHeight * [self.rowViews count] + self.rowPixelOffset);
}

- (void)buildLoadingView {
    self.loadingView = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.frame.size.height, self.frame.size.width, BOUNCE_OFFSET)];
    self.loadingView.backgroundColor = [UIColor blackColor];    
    UILabel* loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(150.0, 0.25*BOUNCE_OFFSET, 0.25*self.frame.size.width, 0.5*BOUNCE_OFFSET)];
    loadingLabel.text = @"Loading";
    loadingLabel.backgroundColor = [UIColor blackColor];
    loadingLabel.textColor = [UIColor grayColor];
    loadingLabel.font = [loadingLabel.font fontWithSize:22.0];
    [self.loadingView addSubview:loadingLabel];
    self.loadingSpinnerView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.loadingSpinnerView.frame = CGRectMake(110.0, 0.25*BOUNCE_OFFSET, 0.5*BOUNCE_OFFSET, 0.5*BOUNCE_OFFSET);
    self.loadingSpinnerView.color = [UIColor grayColor];
    [self.loadingView addSubview:self.loadingSpinnerView];
}


- (NSMutableArray*)createRows:(NSArray*)_rows withOffSet:(NSInteger)_offset {
    NSMutableArray* dragRows = [NSMutableArray arrayWithCapacity:10];
    for (int i = 0; i < [_rows count]; i++) {
        [dragRows addObject:[self createRow:[_rows objectAtIndex:i] atIndex:i withOffSet:_offset]];
    }
    return dragRows;
}

- (DragRowView*)createRow:(NSArray*)_row atIndex:(NSInteger)_rowIndex withOffSet:(NSInteger)_offset {
    CGRect rowFrame = CGRectMake(0.0, _rowIndex  * self.rowHeight + self.rowPixelOffset, self.frame.size.width, self.rowHeight);
    DragRowView* dragRow = [DragRowView withFrame:rowFrame andItems:_row];
    [self.rowContainerView addSubview:dragRow];
    return dragRow;
}

- (CGRect)rect:(CGRect)_rect withYOffset:(NSInteger)_offset {
    CGFloat y = _rect.origin.y + _offset * self.rowHeight;
    return CGRectMake(_rect.origin.x, y, _rect.size.width, _rect.size.width);
}

- (void)addTopRows:(NSArray*)_rows {
    for (int i = 0; i < [_rows count]; i++) {
        NSInteger offset = -(i * self.rowHeight + self.rowPixelOffset);
        DragRowView* dragView = [self createRow:[_rows objectAtIndex:i] atIndex:i withOffSet:offset];
        [self.rowViews insertObject:dragView atIndex:0];
    }
}

- (void)addBottomRows:(NSArray *)_rows {
    NSInteger totalRows = [self.rowViews count];
    for (int i = 0; i < [_rows count]; i++) {
        DragRowView* dragView = [self createRow:[_rows objectAtIndex:i] atIndex:(i + totalRows) withOffSet:0];
        [self.rowViews addObject:dragView];
    }
    [self setContentSize];
}

- (void)removeBottomRows:(NSInteger)_rows {
    for (int i = 0; i < _rows; i++) {
        DragRowView* dragRow = [self.rowViews lastObject];
        if ([self.delegate respondsToSelector:@selector(removedBottomRow:)]) {
            [self.delegate removedBottomRow:dragRow.items];
        }
        [dragRow removeFromSuperview];
        [self.rowViews removeLastObject];
    }
    [self setContentSize];
}

- (void)removeRowsFromTop:(NSInteger)_rows {
    for (int i = 0; i < _rows; i++) {
        if ([self.delegate respondsToSelector:@selector(removedTopRow:)]) {
            DragRowView* dragRow = [self.rowViews objectAtIndex:i];
            [dragRow removeFromSuperview];
            [self.delegate removedTopRow:dragRow.items];
        }
        [self.rowViews removeObjectAtIndex:i];
    }
}

- (void)bounceViewDown {
    [UIView animateWithDuration:BOUNCE_DURATION 
        delay:BOUNCE_DELAY 
        options:UIViewAnimationOptionCurveEaseOut 
        animations:^{
            self.rowContainerView.frame = CGRectMake(0.0, 0.0, self.frame.size.width, self.frame.size.height);
            self.loadingView.frame = CGRectMake(0.0, self.frame.size.height, self.frame.size.width, BOUNCE_OFFSET);
         }
         completion:^(BOOL _finished) {
             [self addBottomRows:[self.delegate needBottomRows]];
             [self scrollViewUp];
             self.bouncing = NO;
             self.rowContainerView.bounces = YES;
             [self.loadingView removeFromSuperview];
             [self.loadingSpinnerView stopAnimating];
         }
     ];
}

- (void)bounceViewUp {
    [self.loadingSpinnerView startAnimating];
    [self addSubview:self.loadingView];
    [UIView animateWithDuration:BOUNCE_DURATION 
        delay:0.0 
        options:UIViewAnimationOptionCurveEaseOut 
        animations:^{
            self.rowContainerView.frame = CGRectMake(0.0, -BOUNCE_OFFSET, self.frame.size.width, self.frame.size.height);
            self.loadingView.frame = CGRectMake(0.0, self.frame.size.height - BOUNCE_OFFSET, self.frame.size.width, BOUNCE_OFFSET);
        }
        completion:^(BOOL _finished) {
            [self bounceViewDown];
        }
     ];
}

- (void)scrollViewUp {
    __block CGPoint currentContentOffset = self.rowContainerView.contentOffset;
    [UIView animateWithDuration:SCROLL_UP_DURATION 
        delay:0.0 
        options:UIViewAnimationCurveEaseInOut|UIViewAnimationOptionBeginFromCurrentState
        animations:^{
            [self.rowContainerView setContentOffset:CGPointMake(currentContentOffset.x, currentContentOffset.y + self.rowHeight) animated:NO];
        }
        completion:^(BOOL _finished) {
        }
     ];
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
        self.rowContainerView = [[UIScrollView alloc] initWithFrame:_frame];
        self.rowContainerView.showsVerticalScrollIndicator = NO;
        self.rowContainerView.delegate = self;
        self.userInteractionEnabled = YES;
        [self addSubview:self.rowContainerView];
        [self buildLoadingView];
        self.rowBuffer = 0;
        self.bouncing = NO;
        [self initRowParams:_rows];
        self.rowViews = [self createRows:_rows withOffSet:0];
        [self setContentSize];
    }
    return self;
}

#pragma mark -
#pragma mark UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView*)_scrollView {
    NSInteger rowsFromBottom = [self.rowViews count] - self.topRow;
    if (rowsFromBottom < self.rowBuffer && !self.bouncing) {
        [self addBottomRows:[self.delegate needBottomRows]];
    } else if (rowsFromBottom > self.rowBuffer) {
        [self removeBottomRows:(rowsFromBottom - self.rowBuffer)];
    }
    if (self.topRow < self.rowBuffer) {
        if ([self.delegate respondsToSelector:@selector(needTopRows)]) {
            [self addTopRows:[self.delegate needTopRows]];
        }
    } else if (self.topRow > self.rowBuffer) {
        if ([self.delegate respondsToSelector:@selector(removeTopRows:)]) {
            [self removeRowsFromTop:(self.topRow - self.rowBuffer)];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView*)_scrollView {
    NSInteger currentTopRow = _scrollView.contentOffset.y / self.rowHeight;
    if (self.topRow != currentTopRow) {
        self.topRow = currentTopRow;
        if ([self.delegate respondsToSelector:@selector(topRowChanged:)]) {
            [self.delegate topRowChanged:self.topRow];
        }
    }
    CGFloat bounceDetect =  _scrollView.contentOffset.y + _scrollView.frame.size.height;
    if (bounceDetect > _scrollView.contentSize.height && !self.bouncing) {
        self.bouncing = YES;
        _scrollView.bounces = NO;
        CGPoint offset = CGPointMake(_scrollView.contentOffset.x, self.rowContainerView.contentSize.height - _scrollView.frame.size.height);
        [_scrollView setContentOffset:offset animated:NO];
        [self bounceViewUp];
    }
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

@end
