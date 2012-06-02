//
//  FilteredCameraViewController.h
//  photio
//
//  Created by Troy Stribling on 6/1/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface FilteredCameraViewController : UIViewController

@property(nonatomic, weak)   UIView*                        containerView;
@property(nonatomic, strong) GPUImageStillCamera*           stillCamera;
@property(nonatomic, strong) GPUImageOutput<GPUImageInput>* filter;
@property(nonatomic, strong) UIButton*                      takePhotoButton;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

@end
