//
//  ImageDisplay.m
//  photio
//
//  Created by Troy Stribling on 6/27/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageDisplay.h"
#import "UIImageJPEGDataTransformer.h"
#import "Capture.h"


@implementation ImageDisplay

@dynamic image;
@dynamic capture;

+ (void)initialize {
	if (self == [ImageDisplay class]) {
		UIImageJPEGDataTransformer *transformer = [[UIImageJPEGDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
