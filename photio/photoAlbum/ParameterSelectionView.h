//
//  ParameterSelectionView.h
//  photio
//
//  Created by Troy Stribling on 5/19/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParameterSelectionCell.h"

@class ParameterSelectionCell;

@protocol ParameterSelectionViewDelegate;

typedef void (^DisplayAnimation)();

@interface ParameterSelectionView : UIView <UITableViewDataSource, UITableViewDelegate>

@property(readwrite, copy)      DisplayAnimation                    showAnimation;
@property(readwrite, copy)      DisplayAnimation                    hideAnimation;
@property(nonatomic, weak)      id<ParameterSelectionViewDelegate>  delegate;
@property(nonatomic, strong)    NSArray*                            parameters;
@property(nonatomic, strong)    IBOutlet UILabel*                   titleLabel;

+ (id)initInView:(UIView*)_containerView withDelegate:(id<ParameterSelectionViewDelegate>)_delegate showAnimation:(DisplayAnimation)_showAnimation hideAnimation:(DisplayAnimation)_hideAnimation andTitle:(NSString*)_title;
- (void)removeView;

@end

@protocol ParameterSelectionViewDelegate <NSObject>

@required

- (NSArray*)loadParameters;
- (void)configureParemeterCell:(ParameterSelectionCell*)_parameterCell withParameter:(id)_parameter;
- (void)selectedParameter:(id)_parameter;

@end