//
//  Dbi.h
//
//  Created by Troy Stribling on 1/4/09.
//  Copyright 2009 imaginaryProducts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface Dbi : NSObject {
}

+ (BOOL)copyDbFile:(NSString*)_dbFile;
+ (void)close;
+ (BOOL)open;
+ (void)updateWithStatement:(NSString*)statement;
+ (NSInteger)selectIntExpression:(NSString*)statement;
+ (NSString*)selectTextColumn:(NSString*)statement;
+ (NSArray*)selectAllTextColumn:(NSString*)statement;
+ (void)selectForModel:(id)model withStatement:(NSString*)statement andOutputTo:(id)result;
+ (void)selectAllForModel:(id)model withStatement:(NSString*)statement andOutputTo:(NSMutableArray*)results;
+ (void)logError:(NSString*)statement;

@end

@protocol DbiDelegate <NSObject>

+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output;
+ (void)collectFromResult:(sqlite3_stmt*)result andOutputTo:(id)output;

@end
