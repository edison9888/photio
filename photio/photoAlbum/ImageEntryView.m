//
//  ImageEntryView.m
//  photio
//
//  Created by Troy Stribling on 4/5/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageEntryView.h"
#import "UIImage+Resize.h"
#import "Capture.h"
#import "Service.h"
#import "ServiceManager.h"
#import "CaptureManager.h"
#import "ImageDisplay.h"
#import "ViewGeneral.h"
#import "ImageControlView.h"
#import "FilterFactory.h"
#import "Filter.h"

#define MAX_COMMENT_LINES           5
#define COMMENT_YOFFSET             15
#define COMMENT_XOFFEST             20
#define COMMENT_ANIMATION_DURATION  0.5
#define COMMENT_ALPHA               0.5
#define COMMENT_LABEL_ALPHA         0.75

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEntryView (PrivateAPI)

- (void)editImage;
- (void)singleTapImageGesture;
- (void)removeCommentView;
- (UIImage*)scaleImage:(UIImage*)_image;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEntryView

@synthesize delegate, imageEditViewController, capture, commentView, commentLabel;

#pragma mark -
#pragma mark ImageEntryView PrivateAPI

- (void)editImage {
    [self.commentView removeFromSuperview];
    [self.commentLabel removeFromSuperview];
    self.imageEditViewController = [ImageEditViewController inView:self withDelegate:self andCapture:self.capture];
}

- (void)singleTapImageGesture {
    if ([self.delegate respondsToSelector:@selector(didSingleTapImage)]) {
        [self.delegate didSingleTapImage];
    }
}

- (void)removeCommentView {
    __block CGRect commentLableRect = self.commentLabel.frame;
    __block CGRect commentViewRect = self.commentView.frame;
    [UIView animateWithDuration:COMMENT_ANIMATION_DURATION 
        animations:^{
            self.commentLabel.frame = CGRectMake(commentLableRect.origin.x, 
                                                 self.frame.size.height, 
                                                 commentLableRect.size.width, 
                                                 commentLableRect.size.height);
            self.commentView.frame = CGRectMake(commentViewRect.origin.x, 
                                                self.frame.size.height, 
                                                commentViewRect.size.width, 
                                                commentViewRect.size.height);
        }
        completion:^(BOOL _finished) {
            [self.commentView removeFromSuperview];
            [self.commentLabel removeFromSuperview];
            self.commentLabel.frame = commentViewRect;
            self.commentView.frame = commentViewRect;
        }
    ];
}

- (UIImage*)scaleImage:(UIImage*)_image {
    return [CaptureManager scaleImage:_image toFrame:self.frame];
}

#pragma mark -
#pragma mark ImageEntryView

+ (id)withFrame:(CGRect)_frame capture:(Capture*)_capture andDelegate:(id<ImageEntryViewDelegate>)_delegate {
    return  [[ImageEntryView alloc] initWithFrame:_frame capture:_capture andDelegate:_delegate];
}

- (id)initWithFrame:(CGRect)_frame capture:(Capture*)_capture andDelegate:(id<ImageEntryViewDelegate>)_delegate {
    if ((self = [super initWithFrame:(CGRect)_frame])) {
        self.capture = _capture;
        self.delegate = _delegate;
        self.contentMode = UIViewContentModeCenter;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        UIImage* displayImage = self.capture.displayImage.image;
        self.image = [UIImage imageWithCGImage:[self scaleImage:displayImage].CGImage scale:displayImage.scale orientation:displayImage.imageOrientation];
        UITapGestureRecognizer* editImageGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editImage)];
        editImageGesture.numberOfTapsRequired = 2;
        editImageGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:editImageGesture];
        UITapGestureRecognizer* sigleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapImageGesture)];
        sigleTapGesture.numberOfTapsRequired = 1;
        sigleTapGesture.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:sigleTapGesture];
        [sigleTapGesture requireGestureRecognizerToFail:editImageGesture];
    }
    return self;
}

- (void)addCommentView {
    if (self.capture.comment) {
        CGSize commentSize = [self.capture.comment sizeWithFont:[UIFont systemFontOfSize:20.0] constrainedToSize:CGSizeMake(self.frame.size.width - 2 * COMMENT_XOFFEST, self.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
        CGRect commentLabelRect = CGRectMake(COMMENT_XOFFEST, (self.frame.size.height - commentSize.height - COMMENT_YOFFSET), self.frame.size.width - 2 * COMMENT_XOFFEST, commentSize.height);
        CGRect commentViewRect = CGRectMake(0.0, self.frame.size.height - commentSize.height - 2 * COMMENT_YOFFSET, self.frame.size.width , commentSize.height + 2 * COMMENT_YOFFSET);
        self.commentLabel = [[UILabel alloc] initWithFrame:commentLabelRect];
        self.commentLabel.text = self.capture.comment;
        self.commentLabel.textColor = [UIColor whiteColor];
        self.commentLabel.font = [UIFont systemFontOfSize:20.0];
        self.commentLabel.backgroundColor = [UIColor clearColor];
        self.commentLabel.alpha = COMMENT_LABEL_ALPHA;
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.lineBreakMode = UILineBreakModeWordWrap;
        self.commentView = [ImageControlView withFrame:commentViewRect];
        self.commentView.alpha = COMMENT_ALPHA;
        self.commentView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.commentView];
        [self addSubview:self.commentLabel];
        UITapGestureRecognizer* commentTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeCommentView)];
        commentTapGesture.numberOfTapsRequired = 1;
        commentTapGesture.numberOfTouchesRequired = 1;
        [self.commentView addGestureRecognizer:commentTapGesture];
    }
}

#pragma mark -
#pragma mark ImageEditViewController


- (void)applyFilter:(Filter*)_filter withValue:(NSNumber*)_value {
    UIImage* displayImage = self.capture.displayImage.image;
    UIImage* filteredImage = [FilterFactory applyFilter:_filter withValue:_value toImage:displayImage];
    self.image = [self scaleImage:filteredImage];
}

- (void)saveFilteredImage:(Filter*)_filter withValue:(NSNumber*)_value {
    self.capture.displayImage.image = [UIImage imageWithCGImage:[self scaleImage:self.image].CGImage scale:self.image.scale orientation:self.image.imageOrientation];
    [CaptureManager saveCapture:capture];
}

- (void)resetFilteredImage {
    UIImage* displayImage = self.capture.displayImage.image;
    self.image = [UIImage imageWithCGImage:[self scaleImage:displayImage].CGImage scale:displayImage.scale orientation:displayImage.imageOrientation];
}

- (void)touchEnabled:(BOOL)_enabled {
    [self.delegate touchEnabled:_enabled];
}

@end
