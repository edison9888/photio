//
//  ParameterSelectionCell.h
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ParameterSelectionCellDelegate;

@interface ParameterSelectionCell : UITableViewCell

@property(nonatomic, weak)   id<ParameterSelectionCellDelegate> parameterCellDelegate;
@property(nonatomic, strong) IBOutlet UIImageView*              parameterIcon;
@property(nonatomic, strong) IBOutlet UILabel*                  parameterLabel;
@property(nonatomic, strong) IBOutlet UIImageView*              parameterDeleteIcon;
@property(nonatomic, assign) BOOL                               inEditMode;
@property(nonatomic, assign) CGFloat                            parameterLabelWidth;

- (void)enterEditMode;
- (void)leaveEditMode;

@end

@protocol ParameterSelectionCellDelegate <NSObject>

@required 

- (void)didDeleteParameter:(ParameterSelectionCell*)_cell;

@end