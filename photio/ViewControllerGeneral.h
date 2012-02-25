//
//  ViewControllerGeneral.h
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CameraViewController.h"
#import "ImageInspectViewController.h"

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewControllerGeneral : NSObject {
    ImageInspectViewController* imageInspectViewController;
}

//-----------------------------------------------------------------------------------------------------------------------------------
@property(nonatomic, retain) ImageInspectViewController* imageInspectViewController;

//-----------------------------------------------------------------------------------------------------------------------------------
+ (ViewControllerGeneral*)instance;

//-----------------------------------------------------------------------------------------------------------------------------------
- (ImageInspectViewController*)showImageInspectView:(UIView*)containerView;
- (void)removeImageInspectView;
- (void)imageInspectViewWillAppear;
- (void)imageInspectWillDisappear;


@end
