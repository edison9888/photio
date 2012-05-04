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

@property(nonatomic, strong) ImageEditCommentView*      imageEditCommentView;
@property(nonatomic, strong) ImageMetaDataToolsView*    imageMetaDataToolsView;
          
@end
