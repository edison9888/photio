//
//  DiagonalGestrureRecognizer.h
//  photio
//
//  Created by Troy Stribling on 4/11/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

@protocol DiagonalGestrureRecognizerDelegate;

@interface DiagonalGestrureRecognizer : UIGestureRecognizer {
}

@property(nonatomic, weak)   id<DiagonalGestrureRecognizerDelegate>    gestureDelegate;
@property(nonatomic, weak)   UIView*                                   relativeView;
@property(nonatomic, assign) BOOL                                      strokeUp;
@property(nonatomic, assign) CGPoint                                   midPoint;

+ (id)initWithDelegate:(id<DiagonalGestrureRecognizerDelegate>)_gestureDelegate inView:(UIView*)_view relativeToView:(UIView*)_relativeView;
- (id)initWithDelegate:(id<DiagonalGestrureRecognizerDelegate>)_gestureDelegate inView:(UIView*)_view relativeToView:(UIView*)_relativeView;
- (void)reset;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event;

@end

@protocol DiagonalGestrureRecognizerDelegate <NSObject>

@optional

-(void)didCheck;
-(void)didDiagonalSwipe;

@end