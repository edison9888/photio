//
//  TakePhotoView.m
//  photio
//
//  Created by Troy Stribling on 5/12/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "TakePhotoView.h"
#import <QuartzCore/QuartzCore.h>


@implementation TakePhotoView

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
        self.layer.cornerRadius = 10.0f;
        self.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0].CGColor;
        self.layer.borderWidth = 1.0f;
    }
    return self;
}

@end
