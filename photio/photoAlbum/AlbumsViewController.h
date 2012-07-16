//
//  AlbumsViewController.h
//  photio
//
//  Created by Troy Stribling on 7/15/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DragGridView.h"

@interface AlbumsViewController : UIViewController <DragGridViewDelegate>

@property(nonatomic, weak)   UIView*            containerView;
@property(nonatomic, strong) DragGridView*      dragGridView;
@property(nonatomic, assign) NSInteger          imagesPerAlbum;    

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil inView:(UIView*)_containerView;

@end
