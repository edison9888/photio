//
//  ImageEditView.m
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageEditView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEditView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEditView

@synthesize containerView;

#pragma mark -
#pragma mark ImageEditView (PrivateAPI)

#pragma mark -
#pragma mark ImageEditView

+ (id)inView:(UIView*)_containerView {
    return [[ImageEditView alloc] initInView:(UIView*)_containerView];
}

- (id)initInView:(UIView*)_containerView {
    self = [super initWithFrame:_containerView.frame];
    if (self) {
        self.containerView = _containerView;
    }
    return self;
}

@end
