//
//  LocaleView.h
//  photio
//
//  Created by Troy Stribling on 3/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocaleView : UIView {
    UITextField*        localeNameView;
    NSMutableArray*     photoViews;
}

@property (nonatomic, strong) UITextField*    localeNameView;
@property (nonatomic, strong) NSMutableArray* photoViews;

+ (id)withFrame:(CGRect)_frame andLocale:(NSString*)_locale;
- (id)initWithFrame:(CGRect)_frame andLocale:(NSString*)_locale;

@end
