//
//  Capture.m
//  photio
//
//  Created by Troy Stribling on 4/7/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "Capture.h"
#import "Locale.h"
#import "UIImageToDataTransformer.h"


@implementation Capture

@dynamic comment;
@dynamic createdAt;
@dynamic image;
@dynamic latitude;
@dynamic longitude;
@dynamic thumbnail;
@dynamic locale;

+ (void)initialize {
	if (self == [Capture class]) {
		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
	}
}

@end
