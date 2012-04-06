//
//  ImageInspectView.h
//  photio
//
//  Created by Troy Stribling on 4/5/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageInspectView : UIImageView

@property(nonatomic, retain) UIImage* capture;

+ (id)withFrame:(CGRect)_frame andCapture:(UIImage*)_capture;
- (id)initWithFrame:(CGRect)_frame andCapture:(UIImage*)_capture;

@end
