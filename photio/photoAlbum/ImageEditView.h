//
//  ImageEditView.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageEditView : UIView

@property(nonatomic, strong) UIView*            containerView;
@property(nonatomic, strong) IBOutlet UIView*   imageControlsView;
@property(nonatomic, strong) IBOutlet UIView*   imageFiltersView;

+ (id)inView:(UIView*)_containerView;

@end
