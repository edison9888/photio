//
//  BuiltInFilter.h
//  photio
//
//  Created by Troy Stribling on 5/16/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Filter.h"

@interface BuiltInFilter : Filter

@property(nonatomic, strong) CIContext*     context;
@property(nonatomic, strong) CIFilter*      filter;
@property(nonatomic, strong) CIImage*       image;
@property(nonatomic, strong) NSString*      filterAttribute;
@property(nonatomic, assign) BOOL           changedFilterAttribute;

+ (id)filter:(NSString*)_filterName andAttribute:(NSString*)_attribute ;
- (id)initWithFilter:(NSString*)_filterName andAttribute:(NSString*)_attribute ;

@end

