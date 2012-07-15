//
//  ImageThumbnail.m
//  photio
//
//  Created by Troy Stribling on 6/27/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "ImageThumbnail.h"
#import "UIImagePNGDataTransformer.h"
#import "Capture.h"


@implementation ImageThumbnail

@dynamic image;
@dynamic capture;

+ (void)initialize {
	if (self == [ImageThumbnail class]) {
		UIImagePNGDataTransformer *transformer = [[UIImagePNGDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
