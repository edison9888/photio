//
//  DragGridView.m
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "DragGridView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface DragGridView (PrivateAPI)
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation DragGridView

@synthesize transitionGestureRecognizer, columns;

#pragma mark -
#pragma mark UIViewController

+ (id)withFrame:(CGRect)_rect {
    return [[DragGridView alloc] initWithFrame:_rect];;
}

- (id)initWithFrame:(CGRect)_frame {
    if ((self = [super initWithFrame:_frame])) {
        self.transitionGestureRecognizer = [TransitionGestureRecognizer initWithDelegate:self inView:self relativeToView:self];
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
