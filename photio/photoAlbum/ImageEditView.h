//
//  ImageEditView.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageControlView;
@class ParameterSliderView;

@protocol ImageEditViewDelegate;

@interface ImageEditView : UIView

@property(nonatomic, weak)   id<ImageEditViewDelegate>          delegate;
@property(nonatomic, strong) UIView*                            containerView;
@property(nonatomic, strong) IBOutlet ParameterSliderView*      parameterSlider;
@property(nonatomic, strong) IBOutlet ImageControlView*         imageControlsView;
@property(nonatomic, strong) IBOutlet ImageControlView*         imageFiltersView;

+ (id)inView:(UIView*)_containerView withDelegate:(id<ImageEditViewDelegate>)_delegate;

@end

@protocol ImageEditViewDelegate <NSObject>

@end
