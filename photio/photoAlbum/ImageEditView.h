//
//  ImageEditView.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageEditControlView;

@interface ImageEditView : UIView

@property(nonatomic, strong) UIView*                            containerView;
@property(nonatomic, strong) IBOutlet ImageEditControlView*     imageControlsView;
@property(nonatomic, strong) IBOutlet ImageEditControlView*     imageFiltersView;

+ (id)inView:(UIView*)_containerView;

@end
