//
//  ImageMetaDataEditView.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageEditControlView;

@interface ImageMetaDataEditView : UIView

@property(nonatomic, strong) UIView*                            containerView;
@property(nonatomic, strong) IBOutlet ImageEditControlView*     imageCommentView;
@property(nonatomic, strong) IBOutlet ImageEditControlView*     imageShareView;
 
+ (id)inView:(UIView*)_containerView;
- (IBAction)exportToCameraRoll:(id)sender;
- (IBAction)tweet:(id)sender;

@end
