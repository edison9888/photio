//
//  ImageControlView.m
//  photio
//
//  Created by Troy Stribling on 5/5/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageControlView.h"
#import <QuartzCore/QuartzCore.h>

@interface ImageControlView (PrivateAPI)
@end

@implementation ImageControlView

+ (id)withFrame:(CGRect)_frame {
    ImageControlView* controlView = [[ImageControlView alloc] initWithFrame:_frame];
    [controlView configureLayer];
    return controlView;
}

- (id)initWithCoder:(NSCoder *)coder { 
    self = [super initWithCoder:coder];
    if (self) {
        [self configureLayer];
    }
    return self;
}

- (void)configureLayer {
    self.layer.cornerRadius = 20.0f;
    self.layer.borderColor = [UIColor colorWithRed:0.75 green:0.75 blue:0.75 alpha:1.0].CGColor;
    self.layer.borderWidth = 1.0f;
}

@end
