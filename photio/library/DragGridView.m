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

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DragGridView

@synthesize delegate, transitionGestureRecognizer, rowViews, rowHeight, rowsInView, rowStartView, rowPixelOffset, scrollSteps, 
            rowContainerView, deltaTime, inAnimation;

#pragma mark -
#pragma mark DragGridView PrivatAPI

- (void)initRowParams:(NSMutableArray*)_rows {
    if ([_rows count] > 0) {
        UIView* item = [[_rows objectAtIndex:0] objectAtIndex:0];
        self.rowHeight = item.frame.size.height;
        self.rowsInView = self.frame.size.height / self.rowHeight;
        self.rowPixelOffset = (self.frame.size.height - self.rowsInView * self.rowHeight) / (self.rowsInView *2);
    }
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
    self.rowContainerView.contentSize = CGSizeMake(self.frame.size.width, self.rowHeight * [self.rowViews count]);
}

- (CGRect)rect:(CGRect)_rect withYOffset:(NSInteger)_offset {
    CGFloat y = _rect.origin.y + _offset * self.rowHeight;
    return CGRectMake(_rect.origin.x, y, _rect.size.width, _rect.size.width);
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
        self.userInteractionEnabled = YES;
        [self addSubview:self.rowContainerView];
        self.inAnimation = NO;
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
