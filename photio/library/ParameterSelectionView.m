//
//  ParameterSelectionView.m
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ParameterSelectionView.h"
#import "AddParameterView.h"
#import "ImageEditView.h"
#import "UITableViewCell+Extensions.h"
#import "UIView+Extensions.h"
#import "FilterFactory.h"
#import "FilterPalette.h"

#define PARAMETER_TABEL_CELL_HEIGHT             70.0
#define FILTER_CLASS_VIEW_ANIMATION_DURATION    0.3
#define VIEW_ANIMATION_DURATION                 0.2

@interface ParameterSelectionView (PrivayeAPI)

- (void)showView;
- (void)removeView;
- (void)deleteCell:(UIGestureRecognizer*)gestureRecognizer;
- (void)deleteParameterAtIndexPath:(NSIndexPath*)_indexPath;
- (IBAction)addParameter:(id)sender;
- (IBAction)done:(id)sender;

@end

@implementation ParameterSelectionView

@synthesize delegate, showAnimation, hideAnimation, containerView, parameters, titleLabel, addParameterView, parameterListView, doneView;

#pragma mark -
#pragma mark ParameterSelectionView (PrivateAPI)

- (void)showView {
    __block CGRect oldFrame = self.frame;
    [UIView animateWithDuration:VIEW_ANIMATION_DURATION
         delay:0
         options:UIViewAnimationOptionCurveLinear
         animations:self.showAnimation         
         completion:^(BOOL _finished) {
             [UIView animateWithDuration:FILTER_CLASS_VIEW_ANIMATION_DURATION
                 delay:0
                 options:UIViewAnimationOptionCurveEaseOut
                 animations:^{
                      self.frame = CGRectMake(0.0, 0.0, oldFrame.size.width, oldFrame.size.height);
                 } 
                 completion:^(BOOL _finished) {
                 }
            ];
         }
     ];
}

- (IBAction)addParameter:(id)sender {
    [AddParameterView initInView:self.containerView withParameterSelectionView:self];
}

- (IBAction)done:(id)sender {
    [self.delegate done];
}

- (void)deleteCell:(UIGestureRecognizer*)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        UITableViewCell* cell = (UITableViewCell*)gestureRecognizer.view;
        NSIndexPath* indexPath = [self.parameterListView indexPathForCell:cell];
        [self deleteParameterAtIndexPath:indexPath];
    }
}

- (void)deleteParameterAtIndexPath:(NSIndexPath*)_indexPath {
    [self.delegate deleteParameter:[self.parameters objectAtIndex:_indexPath.row]];
    [self loadParameters];
    [self.parameterListView deleteRowsAtIndexPaths:[NSArray arrayWithObject:_indexPath] withRowAnimation:YES];
    
}

#pragma mark -
#pragma mark ParameterSelectionView

+ (id)initInView:(UIView*)_containerView withDelegate:(id<ParameterSelectionViewDelegate>)_delegate showAnimation:(DisplayAnimation)_showAnimation hideAnimation:(DisplayAnimation)_hideAnimation andTitle:(NSString*)_title {
    ParameterSelectionView* parameterView = (ParameterSelectionView*)[UIView loadView:[self class]];
    parameterView.titleLabel.text = _title;
    parameterView.delegate = _delegate;
    parameterView.showAnimation = _showAnimation;
    parameterView.hideAnimation = _hideAnimation;
    parameterView.containerView = _containerView;
    [_containerView addSubview:parameterView];
    return parameterView;
}

- (void)removeView {
    __block CGRect oldFrame = self.frame;
    [UIView animateWithDuration:FILTER_CLASS_VIEW_ANIMATION_DURATION
        delay:0
        options:UIViewAnimationOptionCurveLinear
        animations:^{
             self.frame = CGRectMake(oldFrame.origin.x, -oldFrame.size.height, oldFrame.size.width, oldFrame.size.height);
        } 
        completion:^(BOOL _finished) {
             [self removeFromSuperview];
             self.hideAnimation();
        }
    ];    
}

- (void)loadParameters {
    self.parameters = [self.delegate loadParameters];
}

- (void)reloadData {
    [self.parameterListView reloadData];    
}

#pragma mark -
#pragma mark UIView

- (id)initWithCoder:(NSCoder*)_coder { 
    self = [super initWithCoder:_coder];
    if (self) {
    }
    return self;
}

- (void)didMoveToSuperview {
    [self loadParameters];
    if ([self.delegate canEdit]) {
        self.doneView.image = [UIImage imageNamed:@"apply"];
        self.addParameterView.hidden = NO;
    } else {
        self.addParameterView.hidden = YES;
    }
    self.frame = CGRectMake(self.frame.origin.x, - self.frame.size.height, self.frame.size.width, self.frame.size.height);
    [self showView];
}

#pragma mark -
#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
    return PARAMETER_TABEL_CELL_HEIGHT;
}

#pragma mark -
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.parameters count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    ParameterSelectionCell* cell = (ParameterSelectionCell*)[UITableViewCell loadCell:[ParameterSelectionCell class]];
    [self.delegate configureParemeterCell:cell withParameter:[self.parameters objectAtIndex:indexPath.row]];
    if ([self.delegate canEdit]) {
        UISwipeGestureRecognizer* swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(deleteCell:)];
        [swipeGesture setDirection:UISwipeGestureRecognizerDirectionRight];
        [cell addGestureRecognizer:swipeGesture];
    }
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [self.delegate selectedParameter:[self.parameters objectAtIndex:indexPath.row]];    
}

@end
