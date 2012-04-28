//
//  Capture.h
//  photio
//
//  Created by Troy Stribling on 4/28/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Image, Locale, Tag;

@interface Capture : NSManagedObject

@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSDate * createdAt;
@property (nonatomic, retain) NSString * dayIdentifier;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) id thumbnail;
@property (nonatomic, retain) Image *image;
@property (nonatomic, retain) Locale *locale;
@property (nonatomic, retain) Tag *tag;

@end
