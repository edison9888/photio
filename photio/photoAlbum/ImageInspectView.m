//
//  ImageInspectView.m
//  photio
//
//  Created by Troy Stribling on 4/5/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageInspectView.h"
#import "UIImage+Resize.h"
#import "Capture.h"
#import "Image.h"
#import "ViewGeneral.h"
#import "ImageControlView.h"

#define MAX_COMMENT_LINES           5
#define COMMENT_YOFFSET             15
#define COMMENT_XOFFEST             20
#define COMMENT_ANIMATION_DURATION  0.5
#define COMMENT_ALPHA               0.3

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageInspectView (PrivateAPI)

- (void)editImage;
- (void)finishedSavingToCameraRoll:image:(UIImage*)_image didFinishSavingWithError:(NSError*)_error contextInfo:(void*)_context;
- (void)singleTapGesture;
- (void)removeCommentView;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageInspectView

@synthesize delegate, capture, commentView, commentLabel, latitude, longitude, createdAt, comment, rating;

#pragma mark -
#pragma mark ImageInspectView PrivateAPI

- (void)editImage {
    [self.commentView removeFromSuperview];
    [self.commentLabel removeFromSuperview];
    __block ViewGeneral* viewGeneral = [ViewGeneral instance];
    [viewGeneral initImageEditView:self];
    viewGeneral.imageEditViewController.delegate = self;
    viewGeneral.imageEditViewController.view.alpha = 0.0;
    [viewGeneral.imageEditViewController updateComment:self.comment andRating:self.rating];
    [UIView animateWithDuration:IMAGE_EDIT_VIEW_DURATION 
        animations:^{
            viewGeneral.imageEditViewController.view.alpha = 1.0;
        }
        completion:^(BOOL _finshed) {
        }
    ];
}

- (void)finishedSavingToCameraRoll:image:(UIImage*)_image didFinishSavingWithError:(NSError*)_error contextInfo:(void*)_context {
    if (_error) {
        [[[UIAlertView alloc] initWithTitle:[_error localizedDescription] message:[_error localizedFailureReason] delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK button title") otherButtonTitles:nil] show];
    }
}

- (void)singleTapImageGesture {
    if ([self.delegate respondsToSelector:@selector(didSingleTapImage)]) {
        [self.delegate didSingleTapImage];
    }
}

- (void)removeCommentView {
    [UIView animateWithDuration:COMMENT_ANIMATION_DURATION 
        animations:^{
            self.commentView.alpha = 0.0;
            self.commentLabel.alpha = 0.0;
        }
        completion:^(BOOL _finished) {
            [self.commentView removeFromSuperview];
            [self.commentLabel removeFromSuperview];
            self.commentView.alpha = COMMENT_ALPHA;
            self.commentLabel.alpha = 1.0;
        }
    ];
}

#pragma mark -
#pragma mark ImageInspectView

+ (id)withFrame:(CGRect)_frame andCapture:(Capture*)_capture {
    ImageInspectView* imageView = [[ImageInspectView alloc] initWithFrame:_frame capture:_capture.image.image date:_capture.createdAt 
        andLocation:CLLocationCoordinate2DMake([_capture.latitude doubleValue], [_capture.longitude doubleValue])];
    imageView.comment = _capture.comment;
    [imageView addCommentView];
    imageView.rating = _capture.rating;
    return  imageView;
}

+ (id)withFrame:(CGRect)_frame capture:(UIImage*)_capture andLocation:(CLLocationCoordinate2D)_location {
    ImageInspectView* imageView = [[ImageInspectView alloc] initWithFrame:_frame capture:_capture date:[NSDate date] andLocation:_location];
    return imageView;
}

- (id)initWithFrame:(CGRect)_frame capture:(UIImage*)_capture date:(NSDate*)_date andLocation:(CLLocationCoordinate2D)_location {
    if ((self = [super initWithFrame:(CGRect)_frame])) {
        self.latitude = [NSNumber numberWithDouble:_location.latitude];
        self.longitude = [NSNumber numberWithDouble:_location.longitude];
        self.createdAt = _date;
        self.capture = _capture;
        UIImageOrientation imageOrientaion = _capture.imageOrientation;
        if (imageOrientaion == UIImageOrientationDown || imageOrientaion == UIImageOrientationUp) {
            CGFloat imageAspectRatio = _capture.size.height / _capture.size.width;
            CGFloat scaledImageHeight = imageAspectRatio * self.frame.size.width;
            CGSize scaledImageSize = CGSizeMake(self.frame.size.width, scaledImageHeight);
            self.image = [_capture scaleToSize:scaledImageSize];
        } else {
            self.image = [_capture scaleToSize:_frame.size];
        }
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
        self.contentMode = UIViewContentModeCenter;
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
    if (self.comment) {
        CGSize commentSize = [self.comment sizeWithFont:[UIFont systemFontOfSize:20.0] constrainedToSize:self.frame.size lineBreakMode:UILineBreakModeWordWrap];
        self.commentLabel = [[UILabel alloc] initWithFrame:CGRectMake(COMMENT_XOFFEST, (self.frame.size.height - commentSize.height - COMMENT_YOFFSET), self.frame.size.width - 2 * COMMENT_XOFFEST, commentSize.height)];
        commentLabel.text = self.comment;
        self.commentView = [ImageControlView withFrame:CGRectMake(0.0, self.frame.size.height - commentSize.height - 2 * COMMENT_YOFFSET, self.frame.size.width , commentSize.height + 2 * COMMENT_YOFFSET)];
        self.commentView.alpha = COMMENT_ALPHA;
        self.commentView.backgroundColor = [UIColor blackColor];
        self.commentLabel.textColor = [UIColor whiteColor];
        self.commentLabel.font = [UIFont systemFontOfSize:20.0];
        self.commentLabel.backgroundColor = [UIColor clearColor];
        self.commentLabel.alpha = 2.0 * COMMENT_ALPHA;
        self.commentLabel.numberOfLines = 0;
        self.commentLabel.lineBreakMode = UILineBreakModeWordWrap;
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

- (void)exportToCameraRoll {
    UIImageWriteToSavedPhotosAlbum(self.capture, self, @selector(finishedSavingToCameraRoll::didFinishSavingWithError:contextInfo:), nil);
}

- (void)saveComment:(NSString*)_comment {
    self.comment = _comment;
}

- (void)saveRating:(NSString*)_rating {
    self.rating = _rating;
}

- (void)didFinishEditing {
    if ([self.delegate respondsToSelector:@selector(didFinishEditing:)]) {
        [self.delegate didFinishEditing:self];
    }
}

@end
