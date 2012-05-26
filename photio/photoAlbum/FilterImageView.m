//
//  FilterImageView.m
//  photio
//
//  Created by Troy Stribling on 5/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "FilterImageView.h"
#import "FilterUsage.h"
#import "NSObject+Extensions.h"

@interface FilterImageView (PrivateAPI)

- (void)didSelect;

@end

@implementation FilterImageView

@synthesize delegate, filter, selectGesture;

+ (id)withDelegate:(id<FilterImageViewDelegate>)_delegate andFilter:(FilterUsage*)_filter {
    UIImage* filterImage = [UIImage imageNamed:_filter.imageFilename];
    FilterImageView* view = [[FilterImageView alloc] initWithImage:filterImage];
    view.delegate = _delegate;
    view.filter = _filter;
    return view;
}

- (id)initWithImage:(UIImage*)_image {
    self = [super initWithImage:_image];
    if (self) {
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

- (void)didMoveToSuperview {
}

- (void)didSelect {
    [self.delegate selectedFilter:self.filter];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self nextResponder];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    NSLog(@"FilterImageView: %@", [touch.view className]);
    return YES;
}

@end
