//
//  ImageInspectViewController.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageInspectViewController : UIViewController <UIImagePickerControllerDelegate> {
    __weak UIView*      containerView;
    UIToolbar*          toolBar;    
    UIImageView*        imageView;
    NSMutableArray*     captures;
    NSInteger           captureIndex;
}

@property(nonatomic, weak)   UIView*                containerView;
@property(nonatomic, retain) IBOutlet UIToolbar*    toolBar;
@property(nonatomic, retain) IBOutlet UIImageView*  imageView;
@property(nonatomic, retain) NSMutableArray*        captures;
@property(nonatomic, assign) NSInteger              captureIndex;

+ (id)inView:(UIView*)_containerView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil inView:(UIView*)_containerView;
- (void)loadCaptures:(NSMutableArray*)_captures;
- (IBAction)toCamera:(id)sender;
- (IBAction)toEntries:(id)sender;
- (IBAction)newImages:(id)sender;
- (IBAction)oldImages:(id)sender;

@end
