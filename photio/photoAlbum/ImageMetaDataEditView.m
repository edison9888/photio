//
//  ImageMetaDataEditView.m
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageMetaDataEditView.h"
#import "UIView+Extensions.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageMetaDataEditView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageMetaDataEditView

@synthesize containerView, imageShareView, imageCommentView;

#pragma mark -
#pragma mark ImageMetaDataEditView (PrivateAPI)

#pragma mark -
#pragma mark ImageMetaDataEditView

+ (id)inView:(UIView*)_containerView {
    return [UIView loadView:[self class]];
}

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
    }
    return self;
}

- (IBAction)exportToCameraRoll:(id)sender {
    NSLog(@"Exporting Image");
}

@end
