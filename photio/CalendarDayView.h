//
//  CalendarDayView.h
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarDayView : UIView {
    UITextField*    dayView;
    UIImageView*    photoView;
}

@property (nonatomic, strong) UITextField* dayView;
@property (nonatomic, strong) UIImageView* photoView;

+ (id)withFrame:(CGRect)_frame date:(NSString*)_date andPhoto:(UIImage*)_photo;
- (id)initWithFrame:(CGRect)_frame date:(NSString*)_date andPhoto:(UIImage*)_photo;

@end
