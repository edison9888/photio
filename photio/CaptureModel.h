//
//  CaprtureModel.h
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Dbi.h"

@interface CaptureModel : NSObject <DbiDelegate> {
	NSInteger   pk;
    NSDate*     createdAt;
    NSInteger   localePk;
    NSString*   comment;
}

@property (nonatomic, assign) NSInteger pk;
@property (nonatomic, retain) NSDate*   createdAt;
@property (nonatomic, assign) NSInteger localePk;
@property (nonatomic, retain) NSString* comment;

+ (NSInteger)count;
+ (void)drop;
+ (void)create;
+ (NSMutableArray*)findAll;

- (void)insert;
- (void)destroy;
- (void)update;

@end
