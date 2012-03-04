//
//  DragGridView.h
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"

@interface DragGridView : UIView <TransitionGestureRecognizerDelegate> {
    TransitionGestureRecognizer*    transitionGestureRecognizer;
    NSArray*                        columns;
}

@property (nonatomic, retain) TransitionGestureRecognizer*  transitionGestureRecognizer;
@property (nonatomic, retain) NSArray*                      columns;

+ (id)withFrame:(CGRect)_rect;

@end
