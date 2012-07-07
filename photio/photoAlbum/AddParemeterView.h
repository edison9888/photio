//
//  AddParemeterView.h
//  photio
//
//  Created by Troy Stribling on 7/7/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ParameterSelectionView;

@interface AddParemeterView : UIView

@property(nonatomic, weak)   ParameterSelectionView*    parameterSelectionView;
@property(nonatomic, strong) IBOutlet UITextField*      textField;
@property(nonatomic, strong) IBOutlet UIView*           containerView;

@end
