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
    UIImageView* imageView;
    CameraOverlayViewController* overlayViewController;   
    NSMutableArray* capturedImages;
}

@property (nonatomic, retain) IBOutlet UIImageView* imageView;
@property (nonatomic, retain) CameraOverlayViewController* overlayViewController;
@property (nonatomic, retain) NSMutableArray* capturedImages;

- (IBAction)cameraAction:(id)sender;

@end
