//
//  Capture.m
//  photio
//
//  Created by Troy Stribling on 4/28/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import "Capture.h"
#import "Image.h"
#import "Locale.h"
#import "Tag.h"
#import "UIImageToDataTransformer.h"



@implementation Capture

@dynamic comment;
@dynamic createdAt;
@dynamic dayIdentifier;
@dynamic latitude;
@dynamic longitude;
@dynamic thumbnail;
@dynamic image;
@dynamic locale;
@dynamic tag;

//+ (void)initialize {
//	if (self == [Capture class]) {
//		UIImageToDataTransformer *transformer = [[UIImageToDataTransformer alloc] init];
//		[NSValueTransformer setValueTransformer:transformer forName:@"UIImageToDataTransformer"];
//	}
//}

@end
