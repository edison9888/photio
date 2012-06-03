//
//  ParameterSelectionView.m
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ParameterSelectionView.h"
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

@end

@implementation ParameterSelectionView

@synthesize delegate, showAnimation, hideAnimation, parameters, titleLabel;

#pragma mark -
#pragma mark ImageFilterPaletteView (PrivateAPI)

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

#pragma mark -
#pragma mark ImageFilterPaletteView

+ (id)initInView:(UIView*)_containerView withDelegate:(id<ParameterSelectionViewDelegate>)_delegate showAnimation:(DisplayAnimation)_showAnimation hideAnimation:(DisplayAnimation)_hideAnimation andTitle:(NSString*)_title {
    ParameterSelectionView* parameterView = (ParameterSelectionView*)[UIView loadView:[self class]];
    parameterView.titleLabel.text = _title;
    parameterView.delegate = _delegate;
    parameterView.showAnimation = _showAnimation;
    parameterView.hideAnimation = _hideAnimation;
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

#pragma mark -
#pragma mark UIView

- (id)initWithCoder:(NSCoder*)_coder { 
    self = [super initWithCoder:_coder];
    if (self) {
    }
    return self;
}

- (void)didMoveToSuperview {
    self.parameters = [self.delegate loadParameters];
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
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [self.delegate selectedParameter:[self.parameters objectAtIndex:indexPath.row]];    
}

@end
