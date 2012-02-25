//
//  ImageInspectViewController.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"

@interface ImageInspectViewController : UIViewController <UIImagePickerControllerDelegate, CameraViewControllerDelegate> {
    __weak UIView*               containerView;
    UIToolbar*                   toolBar;    
    UIImageView*                 imageView;
    CameraViewController*        cameraViewController; 
    UIImage*                     capture;
}

@property (nonatomic, weak) UIView* containerView;
@property (nonatomic, retain) IBOutlet UIToolbar* toolBar;
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) CameraViewController*cameraViewController;
@property (nonatomic, retain) UIImage* capture;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

- (IBAction)cameraAction:(id)sender;

@end
