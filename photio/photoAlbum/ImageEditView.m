//
//  ImageEditView.m
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageEditView.h"
#import "ImageControlView.h"
#import "UIView+Extensions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEditView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEditView

@synthesize containerView, imageControlsView, imageFiltersView, delegate;

#pragma mark -
#pragma mark ImageEditView (PrivateAPI)

#pragma mark -
#pragma mark ImageEditView

+ (id)inView:(UIView*)_containerView withDelegate:(id<ImageEditViewDelegate>)_delegate {
    ImageEditView* view = (ImageEditView*)[UIView loadView:[self class]];
    view.delegate = _delegate;
    return view;
}

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

@end
