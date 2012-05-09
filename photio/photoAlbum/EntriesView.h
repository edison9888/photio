//
//  EntriesView.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransitionGestureRecognizer.h"
#import "DiagonalGestureRecognizer.h"
#import "StreamOfViews.h"
#import "ImageInspectView.h"

@protocol EntriesViewDelegate;

@interface EntriesView : UIView <StreamOfViewsDelegate, DiagonalGestureRecognizerDelegate, ImageInspectViewDelegate> {
}

@property(nonatomic, weak)   UIView*                            containerView;
@property(nonatomic, weak)   id<EntriesViewDelegate>            delegate;
@property(nonatomic, strong) DiagonalGestureRecognizer*         diagonalGestures;
@property(nonatomic, strong) StreamOfViews*                     entriesStreamView;

+ (id)withFrame:(CGRect)_frame andDelegate:(id<EntriesViewDelegate>)_delegate;
- (id)initWithFrame:(CGRect)frame andDelegate:(id<EntriesViewDelegate>)_delegate;
- (NSInteger)entryCount;
- (void)addEntry:(ImageInspectView*)_entry;

@end

@protocol EntriesViewDelegate <NSObject>

@optional

- (void)deleteEntry:(UIView*)_entry;
- (void)saveEntry:(UIView*)_entry;
- (void)didRemoveAllEntries:(EntriesView*)_entries;
- (NSMutableArray*)loadEntries;

- (void)dragEntries:(CGPoint)_drag;
- (void)releaseEntries;
- (void)transitionUpFromEntries;
- (void)transitionDownFromEntries;

- (void)didSingleTap:(EntriesView*)_entries;

@end