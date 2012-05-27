//
//  BouncingPanGestureRecognizer.h
//  photio
//
//  Created by Troy Stribling on 5/26/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BouncingPanGestureRecognizer : NSObject

@property (nonatomic, weak)   UIView*                           contentView;
@property (nonatomic, weak)   UIView*                           relativeView;
@property (nonatomic, strong) UIPanGestureRecognizer*           panGestureRecognizer;
@property (nonatomic, assign) CGRect                            contentViewFrame;
@property (nonatomic, assign) CGFloat                           minXOffset;
@property (nonatomic, assign) CGFloat                           bounce;

+ (id)inView:(UIView*)_view relativeToView:(UIView*)_relativeView;
- (id)initInView:(UIView*)_view relativeToView:(UIView*)_relativeView;

@end
