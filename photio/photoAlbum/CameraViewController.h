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
    UIImagePickerController* imagePickerController;    
@private
    UIBarButtonItem *takePictureButton;
}    

@property (nonatomic, weak) id <CameraViewControllerDelegate> cameraDelegate;
@property (nonatomic, retain) UIImagePickerController* imagePickerController;
@property (nonatomic, retain) IBOutlet UIBarButtonItem* takePictureButton;

- (IBAction)done:(id)sender;
- (IBAction)takePhoto:(id)sender;

@end

@protocol CameraViewControllerDelegate
- (void)didTakePicture:(UIImage*)picture;
- (void)didFinishWithCamera;
@end
