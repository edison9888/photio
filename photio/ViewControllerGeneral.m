//
//  ViewControllerGeneral.m
//  photio
//
//  Created by Troy Stribling on 2/22/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ViewControllerGeneral.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static ViewControllerGeneral* thisViewControllerGeneral = nil;

//-----------------------------------------------------------------------------------------------------------------------------------
@interface ViewControllerGeneral (PrivateAPI)

@end

//-----------------------------------------------------------------------------------------------------------------------------------
@implementation ViewControllerGeneral
 
@synthesize imageInspectViewController;

#pragma mark - 
#pragma mark ViewControllerGeneral PrivateApi

#pragma mark - 
#pragma mark ViewControllerGeneral PrivateApi

+ (ViewControllerGeneral*)instance {	
    @synchronized(self) {
        if (thisViewControllerGeneral == nil) {
            thisViewControllerGeneral = [[self alloc] init]; 
        }
    }
    return thisViewControllerGeneral;
}

#pragma mark - 
#pragma mark ImageInspectViewController PrivateApi

- (ImageInspectViewController*)showImageInspectView:(UIView*)containerView {
    if (self.imageInspectViewController == nil) {
        self.imageInspectViewController = [ImageInspectViewController inView:containerView];
    } 
    [containerView addSubview:self.imageInspectViewController.view];
    [self.imageInspectViewController viewWillAppear:NO];
    return self.imageInspectViewController;
}

- (void)removeImageInspectView {
    if (self.imageInspectViewController) {
        [self.imageInspectViewController viewWillDisappear:NO];
        [self.imageInspectViewController.view removeFromSuperview];
    }
}

- (void)imageInspectViewWillAppear {
    [self.imageInspectViewController viewWillAppear:NO];
}

- (void)imageInspectWillDisappear {
    [self.imageInspectViewController viewWillDisappear:NO];
}

@end
