//
//  ImageMetaDataEditView.m
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageMetaDataEditView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageMetaDataEditView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageMetaDataEditView

@synthesize containerView, imageEditCommentView, imageMetaDataToolsView;

#pragma mark -
#pragma mark ImageMetaDataEditView (PrivateAPI)

#pragma mark -
#pragma mark ImageMetaDataEditView

+ (id)inView:(UIView*)_containerView {
    return [[ImageMetaDataEditView alloc] initInView:(UIView*)_containerView];
}

- (id)initInView:(UIView*)_containerView {
    self = [super initWithFrame:_containerView.frame];
    if (self) {
        self.containerView = _containerView;
    }
    return self;
}

@end
