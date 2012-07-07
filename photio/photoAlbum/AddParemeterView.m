//
//  AddParemeterView.m
//  photio
//
//  Created by Troy Stribling on 7/7/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "AddParemeterView.h"
#import "ParameterSelectionView.h"

#define VIEW_ANIMATION_DURATION     0.25

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface AddParemeterView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation AddParemeterView

@synthesize parameterSelectionView, textField, containerView;

#pragma mark -
#pragma mark AddParemeterView (PrivateAPI)

- (void)addInputView {
    CGRect parameterViewRect = self.parameterSelectionView.frame;
    __block CGRect oldFrame = self.containerView.frame;
    __block CGRect newParameterViewRect = CGRectMake(parameterViewRect.origin.x, -parameterViewRect.size.height, parameterViewRect.size.width, parameterViewRect.size.height);
    self.containerView.frame = CGRectMake(oldFrame.origin.x, (oldFrame.origin.y - oldFrame.size.height), oldFrame.size.width, oldFrame.size.height);
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
                  self.containerView.frame = CGRectMake(0.0, 0.0, oldFrame.size.width, oldFrame.size.height);
                  [self.textField becomeFirstResponder];
                } 
                completion:^(BOOL _finished) {
                }
            ];
         }
     ];
}

- (void)removeInputView {
    CGRect parameterViewRect = self.parameterSelectionView.frame;
    __block CGRect oldFrame = self.containerView.frame;
    __block CGRect newParameterViewRect = CGRectMake(parameterViewRect.origin.x, 0.0, parameterViewRect.size.width, parameterViewRect.size.height);
    [UIView animateWithDuration:VIEW_ANIMATION_DURATION 
        delay:0
        options:UIViewAnimationOptionCurveLinear
        animations:^{
            self.containerView.frame = CGRectMake(oldFrame.origin.x, (oldFrame.origin.y - oldFrame.size.height), oldFrame.size.width, oldFrame.size.height);
            [self.textField resignFirstResponder];
        } 
        completion:^(BOOL _finished) {
            [self removeFromSuperview];
            [UIView animateWithDuration:VIEW_ANIMATION_DURATION
                animations:^{
                    self.parameterSelectionView.frame = newParameterViewRect;
                } 
                completion:^(BOOL _finished) {
                }
             ];    
        }
     ];    
}


- (IBAction)cancel:(id)sender {
}

- (IBAction)done:(id)sender {
}

#pragma mark -
#pragma mark AddParemeterView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
