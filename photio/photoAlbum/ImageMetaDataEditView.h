//
//  ImageMetaDataEditView.h
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageEditCommentView;
@class ImageMetaDataToolsView;

@interface ImageMetaDataEditView : UIView

@property(nonatomic, strong) UIView*            containerView;
@property(nonatomic, strong) IBOutlet UIView*   imageCommentView;
@property(nonatomic, strong) IBOutlet UIView*   imageShareView;
 
+ (id)inView:(UIView*)_containerView;
- (IBAction)exportToCameraRoll:(id)sender;

@end
