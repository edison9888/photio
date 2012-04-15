//
//  CalandarDateView.h
//  photio
//
//  Created by Troy Stribling on 4/8/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalandarDateView : UITextField

+ (id)withFrame:(CGRect)_frame andDate:(NSString*)_date;
- (id)initWithFrame:(CGRect)_frame andDate:(NSString*)_date;

@end
