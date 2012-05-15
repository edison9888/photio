//
//  ParameterSliderView.h
//  photio
//
//  Created by Troy Stribling on 5/15/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ParameterSliderViewDelegate;

@interface ParameterSliderView : UIView

@property(nonatomic, weak)   id<ParameterSliderViewDelegate>    delegate;
@property(nonatomic, strong) UIView*                            parameterView;
@property(nonatomic, strong) UIPanGestureRecognizer*            panGesture;
@property(nonatomic, assign) CGFloat                            maxValue;
@property(nonatomic, assign) CGFloat                            minValue;
@property(nonatomic, assign) CGFloat                            initialValue;
@property(nonatomic, assign) CGSize                             parameterViewSize;

- (CGFloat)value;

@end

@protocol ParameterSliderViewDelegate

-(void)valueChanged:(ParameterSliderView*)_parameterSlider;


@end
