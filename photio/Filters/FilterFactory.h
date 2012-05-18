//
//  FilterFactory.h
//  photio
//
//  Created by Troy Stribling on 5/18/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Filter;

@interface FilterFactory : NSObject

+ (Filter*)filter:(NSString*)_filterName;

@end
