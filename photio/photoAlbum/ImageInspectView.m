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
#import "FilterFactory.h"
#import "Filter.h"

#define MAX_COMMENT_LINES           5
#define COMMENT_YOFFSET             15
#define COMMENT_XOFFEST             20
#define COMMENT_ANIMATION_DURATION  0.5
#define COMMENT_ALPHA               0.5
#define COMMENT_LABEL_ALPHA         0.75

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageInspectView (PrivateAPI)

- (void)editImage;
- (void)finishedSavingToCameraRoll:image:(UIImage*)_image didFinishSavingWithError:(NSError*)_error contextInfo:(void*)_context;
- (void)singleTapGesture;
- (void)removeCommentView;
- (UIImage*)scaleImage:(UIImage*)_image;
- (UIImage*)captureToUpOrientation:(UIImage*)_image;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageInspectView

@synthesize delegate, imageEditViewController, capture, unfilteredImage, commentView, commentLabel, latitude, longitude, createdAt, comment, rating;

#pragma mark -
#pragma mark ImageInspectView PrivateAPI

- (void)editImage {
    [self.commentView removeFromSuperview];
    [self.commentLabel removeFromSuperview];
    self.imageEditViewController = [ImageEditViewController inView:self withDelegate:self];
    [self.imageEditViewController updateComment:self.comment andRating:self.rating];
}

- (void)finishedSavingToCameraRoll:image:(UIImage*)_image didFinishSavingWithError:(NSError*)_error contextInfo:(void*)_context {
    [[ViewGeneral instance] removeProgressView];
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
    CGFloat imageAspectRatio = _image.size.height / _image.size.width;
    CGFloat scaledImageHeight = MAX(self.frame.size.width * imageAspectRatio, self.frame.size.height);
    CGFloat scaledImageWidth = self.frame.size.width;
    if (imageAspectRatio < 1.0) {
        CGFloat screenAspectRatio = self.frame.size.height / self.frame.size.width;
        scaledImageWidth = MIN(self.frame.size.height / imageAspectRatio, self.frame.size.width);
        scaledImageHeight = scaledImageWidth * screenAspectRatio;
//        scaledImageWidth = MAX(self.frame.size.width / imageAspectRatio, self.frame.size.width);
    }
    CGSize scaledImageSize = CGSizeMake(scaledImageWidth, scaledImageHeight);
    return [_image scaleToSize:scaledImageSize];
}

- (UIImage*)captureToUpOrientation:(UIImage*)_image {
    CGRect origRect = CGRectMake(0, 0, _image.size.width, _image.size.width);
    CGRect transposedRect = CGRectMake(0, 0, _image.size.height, _image.size.width);
    BOOL drawTransposed;
    switch (_image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            drawTransposed = YES;
            break;            
        default:
            drawTransposed = NO;
    }
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformTranslate(transform, 0.0, _image.size.height);
    transform = CGAffineTransformScale(transform, 1.0, -1.0);
    UIImageOrientation imageOrientation = _image.imageOrientation;
    switch (_image.imageOrientation) {
        case UIImageOrientationDown:
            break;
        case UIImageOrientationUp:
            break;
        case UIImageOrientationRight:
            transform = CGAffineTransformTranslate(transform, 0.0, _image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationLeft:
            transform = CGAffineTransformTranslate(transform, _image.size.width, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;            
        default:
            break;
    }
    UIGraphicsBeginImageContext(_image.size);
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGImageRef imageRef = _image.CGImage;
        CGContextConcatCTM(ctx, transform);
        CGContextDrawImage(ctx, drawTransposed ? transposedRect : origRect, imageRef);
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
        self.capture = [self captureToUpOrientation:_capture];
        self.unfilteredImage = [self scaleImage:self.capture];
        self.image = self.unfilteredImage;
        self.contentMode = UIViewContentModeCenter;
        self.clipsToBounds = YES;
        self.userInteractionEnabled = YES;
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
        CGSize commentSize = [self.comment sizeWithFont:[UIFont systemFontOfSize:20.0] constrainedToSize:CGSizeMake(self.frame.size.width - 2 * COMMENT_XOFFEST, self.frame.size.height) lineBreakMode:UILineBreakModeWordWrap];
        CGRect commentLabelRect = CGRectMake(COMMENT_XOFFEST, (self.frame.size.height - commentSize.height - COMMENT_YOFFSET), self.frame.size.width - 2 * COMMENT_XOFFEST, commentSize.height);
        CGRect commentViewRect = CGRectMake(0.0, self.frame.size.height - commentSize.height - 2 * COMMENT_YOFFSET, self.frame.size.width , commentSize.height + 2 * COMMENT_YOFFSET);
        self.commentLabel = [[UILabel alloc] initWithFrame:commentLabelRect];
        self.commentLabel.text = self.comment;
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

- (void)exportToCameraRoll {
    [[ViewGeneral instance] showProgressViewWithMessage:@"Exporting to Camera Roll"];
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
        self.imageEditViewController = nil;
    }
}

- (void)applyFilter:(Filter*)_filter withValue:(NSNumber*)_value {
    UIImage* filteredImage = [FilterFactory applyFilter:_filter withValue:_value toImage:self.unfilteredImage];
    self.image = [self scaleImage:filteredImage];
}

- (void)saveFilteredImage:(Filter*)_filter withValue:(NSNumber*)_value {
    self.capture = [FilterFactory applyFilter:_filter withValue:_value toImage:self.capture];
    self.unfilteredImage = [self scaleImage:self.capture];
    self.image = self.unfilteredImage;
}

- (void)resetFilteredImage {
    self.image = self.unfilteredImage;    
}

@end
