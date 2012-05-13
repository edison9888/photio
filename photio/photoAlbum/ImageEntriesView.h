//
//  ImageEntriesView.h
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

@protocol ImageEntriesViewDelegate;

@interface ImageEntriesView : UIView <StreamOfViewsDelegate, DiagonalGestureRecognizerDelegate, ImageInspectViewDelegate> {
}

@property(nonatomic, weak)   UIView*                            containerView;
@property(nonatomic, weak)   id<ImageEntriesViewDelegate>            delegate;
@property(nonatomic, strong) DiagonalGestureRecognizer*         diagonalGestures;
@property(nonatomic, strong) StreamOfViews*                     entriesStreamView;

+ (id)withFrame:(CGRect)_frame andDelegate:(id<ImageEntriesViewDelegate>)_delegate;
- (id)initWithFrame:(CGRect)frame andDelegate:(id<ImageEntriesViewDelegate>)_delegate;
- (NSInteger)entryCount;
- (void)addEntry:(ImageInspectView*)_entry;

@end

@protocol ImageEntriesViewDelegate <NSObject>

@optional

- (void)deleteEntry:(ImageInspectView*)_entry;
- (void)saveEntry:(ImageInspectView*)_entry;
- (void)didRemoveAllEntries:(ImageEntriesView*)_entries;
- (NSMutableArray*)loadEntries;

- (void)dragEntries:(CGPoint)_drag;
- (void)releaseEntries;
- (void)transitionUpFromEntries;
- (void)transitionDownFromEntries;

- (void)didSingleTapEntries:(ImageEntriesView*)_entries;
- (void)didFinishEditing:(ImageInspectView*)_entry;

@end