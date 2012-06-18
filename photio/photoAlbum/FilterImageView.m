//
//  FilterImageView.m
//  photio
//
//  Created by Troy Stribling on 5/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "GPUImage.h"
#import "FilterImageView.h"
#import "Filter.h"
#import "NSObject+Extensions.h"
#import "UIImage+Extensions.h"
#import "FilterSelectedView.h"

@interface FilterImageView (PrivateAPI)

- (void)didSelect;
- (UIImage*)createSelectedImage;

@end

@implementation FilterImageView

@synthesize delegate, filter, selectGesture, selectedView, selected;

#pragma mark -
#pragma mark FilterImageView PrivateAPI

- (void)didSelect {
    if (!self.selected) {
        [self select];
        [self.delegate selectedFilter:self];
    }
}

#pragma mark -
#pragma mark FilterImageView

+ (id)withDelegate:(id<FilterImageViewDelegate>)_delegate andFilter:(Filter*)_filter {
    UIImage* filterImage = [UIImage imageNamed:_filter.imageFilename];
    FilterImageView* view = [[FilterImageView alloc] initWithImage:filterImage];
    view.delegate = _delegate;
    view.filter = _filter;
    return view;
}

- (id)initWithImage:(UIImage*)_image {
    self = [super initWithImage:_image];
    if (self) {
        self.image = _image;
        self.alpha = 0.6f;
        self.selected = NO;
        self.selectedView = [FilterSelectedView withFrame:CGRectMake(0.3*self.frame.size.width, 0.8f*self.frame.size.height, 0.4f*self.frame.size.width, 0.075f*self.frame.size.height)] ;
        self.userInteractionEnabled = YES;
        self.exclusiveTouch = NO;
        self.selectGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didSelect)];
        self.selectGesture.numberOfTapsRequired = 1;
        self.selectGesture.numberOfTouchesRequired = 1;
        self.selectGesture.delegate = self;
        [self addGestureRecognizer:self.selectGesture];
    }
    return self;
}

- (void)select {
    if (!self.selected) {
        [self addSubview:self.selectedView];
        self.selected = YES;
    }
}

- (void)deselect {
    if (self.selected) {
        [self.selectedView removeFromSuperview];
        self.selected = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self nextResponder];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    return YES;
}

@end
