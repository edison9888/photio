//
//  ImageEditViewController.m
//  photio
//
//  Created by Troy Stribling on 5/2/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageEditViewController.h"
#import "ParameterSliderView.h"
#import "NSObject+Extensions.h"

#define SUBVIEW_ANIMATION_DURACTION     0.2

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface ImageEditViewController (PrivateAPI)

- (IBAction)remove:(id)sender;
- (IBAction)singleTap:(id)sender;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation ImageEditViewController

@synthesize delegate, removeGesture, singleTapGesture, containerView, streamView, 
            imageMetaDataEditView, imageEditView, didEdit, didNotSaveFilteredImage;

#pragma mark -
#pragma mark ImageEditViewController (PrivateAPI)

#pragma mark -
#pragma mark ImageEditViewController

+ (id)inView:(UIView*)_containerView withDelegate:(id<ImageEditViewControllerDelegate>)_delegate {
    return [[ImageEditViewController alloc] initWithNibName:@"ImageEditViewController" bundle:nil inView:_containerView withDelegate:_delegate];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView withDelegate:(id<ImageEditViewControllerDelegate>)_delegate {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.delegate = _delegate;
        self.containerView = _containerView;
        self.didEdit = NO;
        self.didNotSaveFilteredImage = YES;
        [self.containerView addSubview:self.view];  
    }
    return self;
}

- (void)updateComment:(NSString*)_comment andRating:(NSString*)_rating {
    [self.imageMetaDataEditView updateComment:_comment];
    [self.imageMetaDataEditView updateRating:_rating];
}

- (IBAction)remove:(id)sender {
    [self hideViews];
    if (self.didNotSaveFilteredImage) {
        [self.delegate resetFilteredImage];
    }
    if (self.didEdit) {
        [self.delegate didFinishEditing];
    }
}

- (IBAction)singleTap:(id)sender {
    if ([self.delegate respondsToSelector:@selector(singleTapImageEditGesture)]) {
        [self.delegate singleTapImageEditGesture];
    }
}

- (void)showViews {    
    [self.containerView addSubview:self.view];

    __block CGRect controlContainerRect = self.imageEditView.controlContainerView.frame;
    __block CGRect filterContainerRect = self.imageEditView.filterContainerView.frame;
    self.imageEditView.controlContainerView.frame = CGRectMake(controlContainerRect.origin.x, -controlContainerRect.size.height, controlContainerRect.size.width, controlContainerRect.size.height);
    self.imageEditView.filterContainerView.frame = CGRectMake(filterContainerRect.origin.x, self.view.frame.size.height, filterContainerRect.size.width, filterContainerRect.size.height);
    
    __block CGRect shareContainerRect = self.imageMetaDataEditView.shareContainerView.frame;
    __block CGRect commentContainerRect = self.imageMetaDataEditView.commentContainerView.frame;
    CGRect initShareViewRect = CGRectMake(shareContainerRect.origin.x, -shareContainerRect.size.height, shareContainerRect.size.width, shareContainerRect.size.height);
    CGRect initCommentRect = CGRectMake(commentContainerRect.origin.x, self.view.frame.size.height, commentContainerRect.size.width, commentContainerRect.size.height);
    self.imageMetaDataEditView.shareContainerView.frame = initShareViewRect;
    self.imageMetaDataEditView.commentContainerView.frame = initCommentRect;
        
    [UIView animateWithDuration:SUBVIEW_ANIMATION_DURACTION 
        delay:0.0
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            self.imageEditView.controlContainerView.frame = controlContainerRect;
            self.imageEditView.filterContainerView.frame = filterContainerRect;
            self.imageMetaDataEditView.shareContainerView.frame = shareContainerRect;
            self.imageMetaDataEditView.commentContainerView.frame = commentContainerRect;
        }
        completion:^(BOOL _finished) {
        }
    ];
}

- (void)hideViews {
    __block CGRect originalControlContainerRect = self.imageEditView.controlContainerView.frame;
    __block CGRect originalFilterContainerRect = self.imageEditView.filterContainerView.frame;
    __block CGRect controlContainerRect = CGRectMake(originalControlContainerRect.origin.x, -originalControlContainerRect.size.height, originalControlContainerRect.size.width, originalControlContainerRect.size.height);
    __block CGRect filterContainerRect = CGRectMake(originalFilterContainerRect.origin.x, self.view.frame.size.height, originalFilterContainerRect.size.width, originalFilterContainerRect.size.height);
    
    __block CGRect originalShareContainerRect = self.imageMetaDataEditView.shareContainerView.frame;
    __block CGRect originalCommentContainerRect = self.imageMetaDataEditView.commentContainerView.frame;
    __block CGRect shareContainerRect = CGRectMake(originalShareContainerRect.origin.x, -originalShareContainerRect.size.height, originalShareContainerRect.size.width, originalShareContainerRect.size.height);
    __block CGRect commentContainerRect = CGRectMake(originalCommentContainerRect.origin.x, self.view.frame.size.height, originalCommentContainerRect.size.width, originalCommentContainerRect.size.height);
        
    [UIView animateWithDuration:SUBVIEW_ANIMATION_DURACTION 
        delay:0.0
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            self.imageEditView.controlContainerView.frame = controlContainerRect;
            self.imageEditView.filterContainerView.frame = filterContainerRect;
            self.imageMetaDataEditView.shareContainerView.frame = shareContainerRect;
            self.imageMetaDataEditView.commentContainerView.frame = commentContainerRect;
        }
        completion:^(BOOL _finished) {
            self.imageEditView.controlContainerView.frame = originalControlContainerRect;
            self.imageEditView.filterContainerView.frame = originalFilterContainerRect;
            self.imageMetaDataEditView.shareContainerView.frame = originalShareContainerRect;
            self.imageMetaDataEditView.commentContainerView.frame = originalCommentContainerRect;
            [self.view removeFromSuperview];
        }
    ];
}


#pragma mark -
#pragma mark UIViewController

- (void)viewDidLoad {
    [self.singleTapGesture requireGestureRecognizerToFail:self.removeGesture];
    self.streamView = [StreamOfViews withFrame:self.view.frame delegate:self relativeToView:self.containerView];
    self.streamView.transitionGestureRecognizer.gestureRecognizer.delegate = self;
    self.streamView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.streamView];
    self.imageEditView = [ImageEditView withDelegate:self];
    self.imageMetaDataEditView = [ImageMetaDataEditView withDelegate:self];
    [self.streamView addView:self.imageEditView];
    [self.streamView addView:self.imageMetaDataEditView];
    [self showViews];
    [super viewDidLoad];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark StreamOfViewsDelegate

- (void)didDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didReleaseUp:(CGPoint)_location {
}

- (void)didReleaseDown:(CGPoint)_location {
}

- (void)didSwipeUp:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didSwipeDown:(CGPoint)_location withVelocity:(CGPoint)_velocity {
}

- (void)didReachMaxDragUp:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
}

- (void)didReachMaxDragDown:(CGPoint)_drag from:(CGPoint)_location withVelocity:(CGPoint)_velocity {    
}

- (void)didRemoveAllViews {
}

#pragma mark -
#pragma mark ImageMetaDataEditViewDelegate

- (void)exportToCameraRoll {
    [self.delegate exportToCameraRoll];
}

- (void)saveComment:(NSString*)_comment {
    self.didEdit = YES;
    [self.delegate saveComment:_comment];
}

- (void)saveRating:(NSString*)_rating {
    self.didEdit = YES;
    [self.delegate saveRating:_rating];
}

#pragma mark -
#pragma mark ImageEditView

- (void)applyFilter:(Filter*)_filter withValue:(NSNumber*)_value {
    [self.delegate applyFilter:_filter withValue:_value];
}

- (void)saveFilteredImage:(Filter*)_filter withValue:(NSNumber*)_value {
    self.didEdit = YES;
    [self.delegate saveFilteredImage:_filter withValue:_value];
}

-(void)resetFilteredImage {
    [self.delegate resetFilteredImage];
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if ([touch.view isKindOfClass:[ParameterSliderView class]]) {
        return NO;
    }
    return YES;
}

@end
