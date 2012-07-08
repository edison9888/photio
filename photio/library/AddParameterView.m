//
//  AddParameterView.m
//  photio
//
//  Created by Troy Stribling on 7/7/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "AddParameterView.h"
#import "ParameterSelectionView.h"
#import "UIView+Extensions.h"

#define VIEW_ANIMATION_DURATION     0.25

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddParameterView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AddParameterView

@synthesize parameterSelectionView, textField, textContainerView;

#pragma mark -
#pragma mark AddParemeterView (PrivateAPI)

- (void)showView {
    CGRect parameterViewRect = self.parameterSelectionView.frame;
    __block CGRect oldFrame = self.textContainerView.frame;
    __block CGRect newParameterViewRect = CGRectMake(parameterViewRect.origin.x, -parameterViewRect.size.height, parameterViewRect.size.width, parameterViewRect.size.height);
    self.textContainerView.frame = CGRectMake(oldFrame.origin.x, (oldFrame.origin.y - oldFrame.size.height), oldFrame.size.width, oldFrame.size.height);
    [UIView animateWithDuration:VIEW_ANIMATION_DURATION
        delay:0
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            self.parameterSelectionView.frame = newParameterViewRect;
        } 
        completion:^(BOOL _finished) {
            [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                delay:0
                options:UIViewAnimationOptionCurveEaseOut
                animations:^{
                  self.textContainerView.frame = CGRectMake(0.0, 0.0, oldFrame.size.width, oldFrame.size.height);
                  [self.textField becomeFirstResponder];
                } 
                completion:^(BOOL _finished) {
                }
            ];
         }
     ];
}

- (void)removeView {
    CGRect parameterViewRect = self.parameterSelectionView.frame;
    __block CGRect oldFrame = self.textContainerView.frame;
    __block CGRect newParameterViewRect = CGRectMake(parameterViewRect.origin.x, 0.0, parameterViewRect.size.width, parameterViewRect.size.height);
    [UIView animateWithDuration:VIEW_ANIMATION_DURATION 
        delay:0
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            self.textContainerView.frame = CGRectMake(oldFrame.origin.x, (oldFrame.origin.y - oldFrame.size.height), oldFrame.size.width, oldFrame.size.height);
            [self.textField resignFirstResponder];
        } 
        completion:^(BOOL _finished) {
            [self removeFromSuperview];
            [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                animations:^{
                    self.parameterSelectionView.frame = newParameterViewRect;
                } 
                completion:^(BOOL _finished) {
                    [self removeFromSuperview];
                }
             ];    
        }
     ];    
}


- (IBAction)cancel:(id)sender {
    [self removeView];
}

- (IBAction)done:(id)sender {
    [self.parameterSelectionView.delegate addParameterNamed:self.textField.text];
    [self.parameterSelectionView loadParameters];
    [self.parameterSelectionView.parameterListView reloadData];
    [self removeView];
}

#pragma mark -
#pragma mark AddParemeterView

+ (id)initInView:(UIView*)_containerView withParameterSelectionView:(ParameterSelectionView*)_parameterSelectionView {
    AddParameterView* view = (AddParameterView*)[UIView loadView:[self class]];
    view.parameterSelectionView = _parameterSelectionView;
    [_containerView addSubview:view];
    return view;
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
    [self showView];
}

@end
