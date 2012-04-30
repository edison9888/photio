//
//  EntriesView.m
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "EntriesView.h"
#import "StreamOfViews.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface EntriesView (PrivateAPI)

- (void)loadEntries;
- (void)didSingleTap;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation EntriesView

@synthesize containerView, delegate, entriesStreamView, diagonalGestures;

#pragma mark -
#pragma mark EntriesView

+ (id)withFrame:(CGRect)_frame andDelegate:(id<EntriesViewDelegate>)_delegate {
    return [[EntriesView alloc] initWithFrame:_frame andDelegate:_delegate];
}

- (id)initWithFrame:(CGRect)_frame andDelegate:(id<EntriesViewDelegate>)_delegate {
    if ((self = [super initWithFrame:_frame])) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        self.delegate = _delegate;
        self.entriesStreamView = [StreamOfViews withFrame:self.frame delegate:self relativeToView:self.containerView];
        self.diagonalGestures = [DiagonalGestureRecognizer initWithDelegate:self];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSingleTap)];
        singleTap.numberOfTapsRequired = 1;
        singleTap.numberOfTouchesRequired = 1;
        [self.entriesStreamView.transitionGestureRecognizer.gestureRecognizer requireGestureRecognizerToFail:self.diagonalGestures];
        [self.diagonalGestures requireGestureRecognizerToFail:singleTap];
        [self addGestureRecognizer:singleTap];
        [self addGestureRecognizer:self.diagonalGestures];
        [self addSubview:self.entriesStreamView];
        [self loadEntries];
    }
    return self;
}

#pragma mark -
#pragma mark EntriesView (PrivateAPI)

- (void)loadEntries {
    for (UIView* entryView in [self.delegate loadEntries]) {
        [self.entriesStreamView addView:entryView];
    }
}

- (void)didSingleTap {
    if ([self.delegate respondsToSelector:@selector(didTap:)]) {
        [self.delegate didTap:self];
    }
}

#pragma mark -
#pragma mark StreamOfViewsDelegate

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(dragEntries:)]) {
        [self.delegate dragEntries:_drag];
    }
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(dragEntries:)]) {
        [self.delegate dragEntries:_drag];
    }
}

- (void)didReleaseUp:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(releaseEntries)]) {
        [self.delegate releaseEntries];
    }
}

- (void)didReleaseDown:(CGPoint)_location {
    if ([self.delegate respondsToSelector:@selector(releaseEntries)]) {
        [self.delegate releaseEntries];
    }
}

- (void)didSwipeUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(transitionUpFromEntries)]) {
        [self.delegate transitionUpFromEntries];
    }
}

- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
    if ([self.delegate respondsToSelector:@selector(transitionDownFromEntries)]) {
        [self.delegate transitionDownFromEntries];
    }
}

- (void)didReachMaxDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(transitionUpFromEntries)]) {
        [self.delegate transitionUpFromEntries];
    }
}

- (void)didReachMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
    if ([self.delegate respondsToSelector:@selector(transitionDownFromEntries)]) {
        [self.delegate transitionDownFromEntries];
    }
}

- (void)didRemoveAllEntries {
    if ([self.delegate respondsToSelector:@selector(didRemoveAllEntries)]) {
        [self.delegate didRemoveAllEntries];
    }
}

#pragma mark -
#pragma mark DiagonalGestrureRecognizerDelegate

-(void)didCheck {
}

-(void)didDiagonalSwipe {
    if ([self.delegate respondsToSelector:@selector(deleteEntry:)]) {
        [self.delegate deleteEntry:[self.entriesStreamView displayedView]];
        [self.entriesStreamView fadeDisplayedViewAndRemove];
    }
}

@end
