//
//  EntriesViewController.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"
#import "DiagonalGestureRecognizer.h"
#import "StreamOfViews.h"

@class ImageInspectView;
@protocol EntriesViewControllerDelegate;

@interface EntriesViewController : UIViewController <StreamOfViewsDelegate, DiagonalGestureRecognizerDelegate> {
}

@property(nonatomic, weak)   UIView*                            containerView;
@property(nonatomic, weak)   id<EntriesViewControllerDelegate>  delegate;
@property(nonatomic, strong) IBOutlet UIGestureRecognizer*      singleTap;
@property(nonatomic, strong) DiagonalGestureRecognizer*         diagonalGestures;
@property(nonatomic, strong) StreamOfViews*                     entriesView;
@property(nonatomic, strong) NSMutableArray*                    entries;

+ (id)inView:(UIView*)_containerView withDelegate:(id<EntriesViewControllerDelegate>)_delegate;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle*)nibBundleOrNil inView:(UIView*)_containerView withDelegate:(id<EntriesViewControllerDelegate>)_delegate;
- (IBAction)didSingleTap:(id)sender;

@end

@protocol EntriesViewControllerDelegate <NSObject>

@required

- (void)deleteEntry:(id)_entry;
- (NSMutableArray*)loadEntries;

@optional

- (void)dragEntries:(CGPoint)_drag;
- (void)releaseEntries;
- (void)transitionUpFromEntries;
- (void)transitionDownFromEntries;
- (void)didRemoveAllEntries;

- (void)didTap:(EntriesViewController*)_entries;

@end