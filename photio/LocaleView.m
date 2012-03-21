//
//  LocaleView.m
//  photio
//
//  Created by Troy Stribling on 3/20/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "LocaleView.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface LocaleView (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LocaleView

@synthesize localeNameView, photoViews;

#pragma mark -
#pragma mark LocaleView PrivatAPI

#pragma mark -
#pragma mark LocaleView

+ (id)withFrame:(CGRect)_frame andLocale:(NSString*)_locale {
    return [[LocaleView alloc]initWithFrame:(CGRect)_frame andLocale:(NSString*)_locale];
}

- (id)initWithFrame:(CGRect)_frame andLocale:(NSString*)_locale {
    if ((self = [super initWithFrame:_frame])) {
        self.photoViews = [NSMutableArray arrayWithCapacity:10];
    }
    return self;
}

@end
