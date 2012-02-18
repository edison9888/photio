//
//  PhotioViewController.h
//  photio
//
//  Created by Troy Stribling on 2/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraOverlayViewController.h"

@interface PhotioViewController : UIViewController <UIImagePickerControllerDelegate, CameraOverlayViewControllerDelegate> {
UIToolbar* myToolbar;    
CameraOverlayViewController* overlayViewController;   
NSMutableArray* capturedImages;
}

@property (nonatomic, retain) IBOutlet UIToolbar* myToolbar;
@property (nonatomic, retain) CameraOverlayViewController* overlayViewController;
@property (nonatomic, retain) NSMutableArray* capturedImages;

- (IBAction)cameraAction:(id)sender;

@end
