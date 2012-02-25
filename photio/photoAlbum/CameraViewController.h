//
//  CameraViewController.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioServices.h>

@protocol CameraViewControllerDelegate;

@interface CameraViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate> {
    __weak id <CameraViewControllerDelegate> cameraDelegate;
    __weak UIView*                           containerView; 
    UIImagePickerController*                 imagePickerController;    
@private
    UIBarButtonItem *takePictureButton;
}    

@property (nonatomic, weak) id <CameraViewControllerDelegate> cameraDelegate;
@property (nonatomic, weak) UIView* containerView;
@property (nonatomic, retain) UIImagePickerController* imagePickerController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* takePictureButton;


+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (IBAction)done:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end

@protocol CameraViewControllerDelegate
- (void)didTakePicture:(UIImage*)picture;
- (void)didFinishWithCamera;
@end
