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

@class ImageInspectView;
@protocol EntriesViewDelegate;

@interface EntriesView : UIView <StreamOfViewsDelegate, DiagonalGestureRecognizerDelegate> {
}

@property(nonatomic, weak)   UIView*                            containerView;
@property(nonatomic, weak)   id<EntriesViewDelegate>            delegate;
@property(nonatomic, strong) DiagonalGestureRecognizer*         diagonalGestures;
@property(nonatomic, strong) StreamOfViews*                     entriesStreamView;

+ (id)withFrame:(CGRect)_frame andDelegate:(id<EntriesViewDelegate>)_delegate;
- (id)initWithFrame:(CGRect)frame andDelegate:(id<EntriesViewDelegate>)_delegate;

@end

@protocol EntriesViewDelegate <NSObject>

@required

- (void)deleteEntry:(id)_entry;
- (NSMutableArray*)loadEntries;

@optional

- (void)dragEntries:(CGPoint)_drag;
- (void)releaseEntries;
- (void)transitionUpFromEntries;
- (void)transitionDownFromEntries;
- (void)didRemoveAllEntries;

- (void)didTap:(EntriesView*)_entries;

@end