//
//  DragGridView.h
//  photio
//
//  Created by Troy Stribling on 3/4/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"

@protocol DragGridViewDelegate;

@interface DragGridView : UIView <TransitionGestureRecognizerDelegate> {
    __weak id<DragGridViewDelegate> delegate;
    TransitionGestureRecognizer*    transitionGestureRecognizer;
    NSMutableArray*                 centerRows;
    NSMutableArray*                 leftRows;
    NSMutableArray*                 rightRows;
    NSInteger                       topRowIndexOffset;
    CGFloat                         rowHeight;
    NSInteger                       rowsInWindow;
    NSInteger                       rowPixelOffset;
}

@property (nonatomic, weak)     id<DragGridViewDelegate>        delegate;
@property (nonatomic, retain)   TransitionGestureRecognizer*    transitionGestureRecognizer;
@property (nonatomic, retain)   NSMutableArray*                 centerRows;
@property (nonatomic, retain)   NSMutableArray*                 leftRows;
@property (nonatomic, retain)   NSMutableArray*                 rightRows;
@property (nonatomic, assign)   NSInteger                       topRowIndexOffset;
@property (nonatomic, assign)   CGFloat                         rowHeight;
@property (nonatomic, assign)   NSInteger                       rowsInWindow;
@property (nonatomic, assign)   NSInteger                       rowPixelOffset;

+ (id)withFrame:(CGRect)_rect andRows:(NSArray*)_rows;
+ (id)withFrame:(CGRect)_rect rows:(NSArray*)_rows andTopIndexOffset:(NSInteger)_indexOffset;
- (id)initWithFrame:(CGRect)_frame rows:(NSArray*)_rows andTopIndexOffset:(NSInteger)_indexOffset;

@end

@protocol DragGridViewDelegate <NSObject>

@required

- (NSArray*)needRows;

@end