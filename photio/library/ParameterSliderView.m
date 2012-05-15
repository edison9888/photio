//
//  ParameterSliderView.m
//  photio
//
//  Created by Troy Stribling on 5/15/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ParameterSliderView.h"
#import <QuartzCore/QuartzCore.h>

@interface ParameterSliderView (PrivateAPI)

- (void)valueChanged;
- (void)configureLayers;

@end

@implementation ParameterSliderView

@synthesize delegate, parameterView, panGesture, maxValue, minValue, initialValue, parameterViewSize;

#pragma mark -
#pragma mark ParameterSlider PrivateAPI

- (void)valueChanged:(UIPanGestureRecognizer*)_panGesture {
    CGPoint dragDelta = [_panGesture translationInView:self];
    CGFloat newWidth = self.parameterViewSize.width + dragDelta.x;
    if (newWidth < 0.0) {
        newWidth = 0.0;
    } else if (newWidth > self.frame.size.width) {
        newWidth = self.frame.size.width;
    }
    switch (_panGesture.state) {
        case UIGestureRecognizerStateBegan:
        case UIGestureRecognizerStateChanged:
            self.parameterView.frame = CGRectMake(0.0, 0.0, newWidth, self.parameterViewSize.height);
            [self.delegate valueChanged:self];
            break;
        case UIGestureRecognizerStateEnded:
            self.parameterViewSize = self.parameterView.frame.size;
            break;
        default:
            break;
    }
}

- (void)configureLayers {
    self.layer.borderColor = self.parameterView.backgroundColor.CGColor;
    self.layer.borderWidth = 1.0f;    
}

#pragma mark -
#pragma mark ParameterSlider

+ (id)withFrame:(CGRect)_frame {
    ParameterSliderView* sliderView = [[ParameterSliderView alloc] initWithFrame:_frame];
    [sliderView configureLayers];
    return sliderView;
}

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(valueChanged:)];
        [self addGestureRecognizer:self.panGesture];
        self.parameterViewSize = CGSizeMake(0.5 * self.frame.size.width, self.frame.size.height);
        self.parameterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.parameterViewSize.width, self.parameterViewSize.height)];
        self.parameterView.backgroundColor = self.backgroundColor;
        [self addSubview:self.parameterView];
        self.backgroundColor = [UIColor clearColor];
        self.minValue = 0.0;
        self.maxValue = 1.0;
        self.initialValue = 0.5;
        [self configureLayers];
    }
    return self;
}

- (CGFloat)value {
    return 0.0;  
}

@end
