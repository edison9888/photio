//
//  ParameterSelectionCell.m
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ParameterSelectionCell.h"

#define EDIT_ANIMATION_DURATION     0.25f

@interface ParameterSelectionCell (PrivateAPI)

- (IBAction)deleteParameter:(id)sender;

@end

@implementation ParameterSelectionCell

@synthesize parameterCellDelegate, parameterIcon, parameterLabel, parameterDeleteIcon, inEditMode, parameterLabelWidth;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)enterEditMode {
    if (!self.inEditMode) {
        self.inEditMode = YES;
        self.parameterLabelWidth = self.parameterLabel.frame.size.width;
        CGRect newDeleteIconRect = CGRectMake(self.parameterDeleteIcon.frame.origin.x - self.parameterDeleteIcon.frame.size.width, self.parameterDeleteIcon.frame.origin.y, self.parameterDeleteIcon.frame.size.width, self.parameterDeleteIcon.frame.size.height);
        CGRect newLabelRect = CGRectMake(self.parameterLabel.frame.origin.x, self.parameterLabel.frame.origin.y, self.frame.size.width - self.parameterDeleteIcon.frame.size.width - self.parameterLabel.frame.origin.x, self.parameterLabel.frame.size.height);
        [UIView animateWithDuration:EDIT_ANIMATION_DURATION 
                delay:0.0f 
                options:UIViewAnimationCurveEaseInOut 
                animations:^{
                    self.parameterDeleteIcon.frame = newDeleteIconRect;
                    self.parameterLabel.frame = newLabelRect;
                }
                completion:^(BOOL _finished) {
                }];
    }
}

- (void)leaveEditMode {
    if (self.inEditMode) {
        self.inEditMode = NO;
        CGRect newDeleteIconRect = CGRectMake(self.frame.size.width, self.parameterDeleteIcon.frame.origin.y, self.parameterDeleteIcon.frame.size.width, self.parameterDeleteIcon.frame.size.height);
        CGRect newLabelRect = CGRectMake(self.parameterLabel.frame.origin.x, self.parameterLabel.frame.origin.y, self.parameterLabelWidth, self.parameterLabel.frame.size.height);
        [UIView animateWithDuration:EDIT_ANIMATION_DURATION 
            delay:0.0f 
            options:UIViewAnimationCurveEaseInOut 
            animations:^{
                 self.parameterDeleteIcon.frame = newDeleteIconRect;
                 self.parameterLabel.frame = newLabelRect;
            }
            completion:^(BOOL _finished) {
            }];
    }
}

- (IBAction)deleteParameter:(id)sender {
    [self.parameterCellDelegate didDeleteParameter:self];
}

@end
