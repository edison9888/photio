//
//  CameraViewController.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"

@protocol CameraViewControllerDelegate;

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, TransitionGestureRecognizerDelegate> {
    __weak id <CameraViewControllerDelegate>    cameraDelegate;
    __weak UIView*                              containerView;
    TransitionGestureRecognizer*                transitionGestureRecognizer;
    UIImageView*                                flashEnabled;
    UIImagePickerController*                    imagePickerController;
}    

@property (nonatomic, weak)     id <CameraViewControllerDelegate>   cameraDelegate;
@property (nonatomic, weak)     UIView*                             containerView;
@property (nonatomic, retain)   IBOutlet UIImageView*               flashEnabled;
@property (nonatomic, retain)   UIImagePickerController*            imagePickerController;
@property (nonatomic, retain)   TransitionGestureRecognizer*        transitionGestureRecognizer;


+ (id)inView:(UIView*)_containerView;
+ (BOOL)cameraIsAvailable;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (IBAction)done:(id)sender;
- (IBAction)takePhoto:(id)sender;
- (IBAction)changeFlashMode:(id)sender;
- (void)setFlashImage;

@end

@protocol CameraViewControllerDelegate
- (void)didTakePicture:(UIImage*)_picture;
- (void)didFinishWithCamera;
@end
