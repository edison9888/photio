//
//  CaprtureModel.h
//  photio
//
//  Created by Troy Stribling on 3/10/12.
//  Copyright (c) 2012 imaginaryProducts. All rights reserved.
//

//-----------------------------------------------------------------------------------------------------------------------------------
#import "CaptureModel.h"

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface CaptureModel (PrivateAPI)

- (void)setAttributesWithStatement:(sqlite3_stmt*)statement;

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation CaptureModel

@synthesize pk, createdAt, localePk;

#pragma mark -
#pragma mark CaptureModel PrivatAPI

- (void)setAttributesWithStatement:(sqlite3_stmt*)statement {
    self.pk = (int)sqlite3_column_int(statement, 0);
}

#pragma mark -
#pragma mark CaptureModel

+ (NSInteger)count {
	return [Dbi selectIntExpression:@"SELECT COUNT(pk) FROM captures"];
}

+ (void)drop {
	[Dbi  updateWithStatement:@"DROP TABLE captures"];
}

+ (void)create {
	[Dbi  updateWithStatement:@"CREATE TABLE captures (pk integer primary key, createdAt date, localePk integer, FOREIGN KEY (localePk) REFERENCES locales(pk))"];
}

+ (NSMutableArray*)findAll {
	NSMutableArray* output = [NSMutableArray arrayWithCapacity:10];	
    [Dbi selectAllForModel:[self class] withStatement:@"SELECT * FROM captures ORDER BY createdAt DESC" andOutputTo:output];
	return output;
}

- (void)insert {
    NSString* insertStatement;
    insertStatement = [NSString stringWithFormat:@"INSERT INTO captures (createdAt, localePk) values ('%@', %d)", 
                          [self createdAtAsString], self.localePk];	
	[Dbi  updateWithStatement:insertStatement];
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (NSString*)createdAtAsString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd hh:mm:ss zzz"];
    NSString* dateString = [df stringFromDate:self.createdAt];
    return dateString;
}

//-----------------------------------------------------------------------------------------------------------------------------------
- (void)destroy {	
	NSString* insertStatement = [NSString stringWithFormat:@"DELETE FROM captures WHERE pk = %d", self.pk];	
	[Dbi  updateWithStatement:insertStatement];
}

- (void)update {
    NSString* updateStatement = [NSString stringWithFormat:@"UPDATE captures SET createdAt = '%@', localePk = %d WHERE pk = %d", 
                                   [self createdAtAsString], self.localePk];	
	[Dbi updateWithStatement:updateStatement];
}

#pragma mark -
#pragma mark DbiDelegate

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectAllFromResult:(sqlite3_stmt*)result andOutputTo:(NSMutableArray*)output {
	CaptureModel* model = [[CaptureModel alloc] init];
	[model setAttributesWithStatement:result];
	[output addObject:model];
}

//-----------------------------------------------------------------------------------------------------------------------------------
+ (void)collectFromResult:(sqlite3_stmt*)result andOutputTo:(id)output {
	[output setAttributesWithStatement:result];
}

@end
