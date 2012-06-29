//
//  ImageJPEG.m
//  photio
//
//  Created by Troy Stribling on 6/26/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageJPEG.h"
#import "UIImageJPEGDataTransformer.h"


@implementation ImageJPEG

@dynamic image;
@dynamic imageId;

+ (void)initialize {
	if (self == [ImageJPEG class]) {
		UIImageJPEGDataTransformer *transformer = [[UIImageJPEGDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
