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
    NSInteger                       indexOffset;
    CGFloat                         rowHeight;
    NSInteger                       rowOffset;
}

@property (nonatomic, weak)     id<DragGridViewDelegate>        delegate;
@property (nonatomic, retain)   TransitionGestureRecognizer*    transitionGestureRecognizer;
@property (nonatomic, retain)   NSMutableArray*                 centerRows;
@property (nonatomic, retain)   NSMutableArray*                 leftRows;
@property (nonatomic, retain)   NSMutableArray*                 rightRows;
@property (nonatomic, assign)   NSInteger                       indexOffset;
@property (nonatomic, assign)   CGFloat                         rowHeight;
@property (nonatomic, assign)   NSInteger                       rowOffset;

+ (id)withFrame:(CGRect)_rect andRows:(NSArray*)_rows;
+ (id)withFrame:(CGRect)_rect rows:(NSArray*)_rows andIndexOffset:(NSInteger)_indexOffset;
- (id)initWithFrame:(CGRect)_frame rows:(NSArray*)_rows andIndexOffset:(NSInteger)_indexOffset;

@end

@protocol DragGridViewDelegate <NSObject>

@required

- (NSArray*)nextRow;

@end