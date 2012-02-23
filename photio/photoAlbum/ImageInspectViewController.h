//
//  ImageInspectViewController.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOverlayViewController.h"

@interface ImageInspectViewController : UIViewController <UIImagePickerControllerDelegate, CameraOverlayViewControllerDelegate> {
    UIToolbar*                   toolBar;    
    UIImageView*                 imageView;
    CameraOverlayViewController* overlayViewController;   
    UIImage*                     capture;
}

@property (nonatomic, retain) IBOutlet UIToolbar* toolBar;
@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) CameraOverlayViewController* overlayViewController;
@property (nonatomic, retain) UIImage* capture;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;

- (IBAction)cameraAction:(id)sender;

@end
