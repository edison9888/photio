//
//  ImageEntriesView.m
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageEntriesView.h"
#import "StreamOfViews.h"
#import "CaptureManager.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEntriesView (PrivateAPI)

- (void)loadEntries;
- (void)singleTapGesture;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEntriesView

@synthesize containerView, delegate, entriesStreamView, diagonalGestures;

#pragma mark -
#pragma mark ImageEntriesView

+ (id)withFrame:(CGRect)_frame andDelegate:(id<ImageEntriesViewDelegate>)_delegate {
    return [[ImageEntriesView alloc] initWithFrame:_frame andDelegate:_delegate];
}

- (id)initWithFrame:(CGRect)_frame andDelegate:(id<ImageEntriesViewDelegate>)_delegate {
    if ((self = [super initWithFrame:_frame])) {
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        self.delegate = _delegate;
        self.entriesStreamView = [StreamOfViews withFrame:self.frame delegate:self relativeToView:self.containerView];
        self.diagonalGestures = [DiagonalGestureRecognizer initWithDelegate:self];
        UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGesture)];
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

- (NSInteger)entryCount {
    return [self.entriesStreamView.streamOfViews count];
}

- (void)addEntry:(ImageEntryView*)_entry {
    _entry.delegate = self;
    [self.entriesStreamView addView:_entry];
}

#pragma mark -
#pragma mark ImageEntriesView (PrivateAPI)

- (void)loadEntries {
    if ([self.delegate respondsToSelector:@selector(loadEntries)]) {
        for (ImageEntryView* entryView in [self.delegate loadEntries]) {
            [self addEntry:entryView];
        }
    }
}

- (void)singleTapGesture {
    if ([self.delegate respondsToSelector:@selector(didSingleTapEntries:)]) {
        [self.delegate didSingleTapEntries:self];
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

- (void)didRemoveAllViews {
    if ([self.delegate respondsToSelector:@selector(didRemoveAllEntries:)]) {
        [self.delegate didRemoveAllEntries:self];
    }
}

#pragma mark -
#pragma mark DiagonalGestrureRecognizerDelegate

-(void)didCheck {
    ImageEntryView* entry = (ImageEntryView*)[self.entriesStreamView displayedView];
    [CaptureManager saveCapture:entry.capture];
    [self.entriesStreamView moveDisplayedViewDownAndRemove];
}

-(void)didDiagonalSwipe {
    ImageEntryView* entry = (ImageEntryView*)[self.entriesStreamView displayedView];
    [CaptureManager deleteCapture:entry.capture];
    [self.entriesStreamView moveDisplayedViewDiagonallyAndRemove];
}

#pragma mark -
#pragma mark ImageEntryViewDelegate

- (void)didSingleTapImage {
    [self singleTapGesture];
}

@end
