//
//  TransitionGestureRecognizer.m
//  photio
//
//  Created by Troy Stribling on 3/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "TransitionGestureRecognizer.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CameraViewController (PrivateAPI)
@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TransitionGestureRecognizer 

@synthesize lastTouch, currentView, nextView;

#pragma mark -
#pragma mark TransitionGestureRecognizer PrivateAPI

#pragma mark -
#pragma mark TransitionGestureRecognizer

+ (id)initInView:(UIView*)_view andTransitionTo:(UIView*)_nextview {
    
}

- (void)touched:(UIPanGestureRecognizer*)_recognizer {
    
}

@end
