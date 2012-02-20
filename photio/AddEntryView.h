//
//  AddEntryView.h
//  photio
//
//  Created by Troy Stribling on 2/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
	kPullToRefreshViewStateUninitialized = 0,
	kPullToRefreshViewStateNormal,
	kPullToRefreshViewStateReady,
	kPullToRefreshViewStateLoading,
    kPullToRefreshViewStateProgrammaticRefresh,
	kPullToRefreshViewStateOffline
} PullToRefreshViewState;

@protocol AddEntryViewDelegate;

@interface AddEntryView : UIView {
	__weak id<AddEntryViewDelegate> entryDelegate;
	UIScrollView *scrollView;
	PullToRefreshViewState state;
	UILabel *subtitleLabel;
	UILabel *statusLabel;
	CALayer *arrowImage;
	CALayer *offlineImage;
	UIActivityIndicatorView *activityView;
}

@property (nonatomic, readonly) UIScrollView *scrollView;
@property (nonatomic, weak) id<AddEntryViewDelegate> entryDelegate;

- (void)refreshLastUpdatedDate;

- (id)initWithScrollView:(UIScrollView *)scrollView;
- (void)finishedLoading;
- (void)beginLoading;
- (void)containingViewDidUnload;

@end

@protocol AddEntryViewDelegate <NSObject>

@optional

- (void)pullToRefreshViewShouldRefresh:(AddEntryView*)view;
- (NSDate *)pullToRefreshViewLastUpdated:(AddEntryView*)view;

@end