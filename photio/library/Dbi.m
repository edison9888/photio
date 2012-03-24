//
//  Dbi.h
//
//  Created by Troy Stribling on 1/4/09.
//  Copyright 2009 imaginaryProducts. All rights reserved.
//

#import "Dbi.h"

//-----------------------------------------------------------------------------------------------------------------------------------
static sqlite3*  sqlDb = nil;
static NSString* dbFilePath = nil;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@interface Dbi (PrivateAPI)

@end

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation Dbi


#pragma mark WebgnosusDbi PrivateAPI

#pragma mark Dbi

+ (BOOL)copyDbFile:(NSString*)_dbFile {	
	NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentFolderPath = [searchPaths objectAtIndex: 0];
	dbFilePath = [documentFolderPath stringByAppendingPathComponent:_dbFile];
    NSString* resourceName = [[_dbFile componentsSeparatedByString:@"."] objectAtIndex:0];
	if (![[NSFileManager defaultManager] fileExistsAtPath: dbFilePath]) {
		NSString *backupDbPath = [[NSBundle mainBundle] pathForResource:resourceName ofType:@"db"];
		if (backupDbPath == nil) {
			return NO;
		} else {
			return [[NSFileManager defaultManager] copyItemAtPath:backupDbPath toPath:dbFilePath error:nil];
		}
	}
	return YES;
}

+ (void)close {
	sqlite3_close(sqlDb);
}

+ (BOOL)open {
	if (sqlite3_open([dbFilePath UTF8String], &sqlDb)) { 
		NSLog (@"error opening database"); 
		return NO;
	} 
	return YES;
}

+ (void)updateWithStatement:(NSString*)statement {
	sqlite3_stmt* statementPrepared;
	sqlite3_prepare_v2 (sqlDb, [statement UTF8String], -1, &statementPrepared, NULL);
	sqlite3_step(statementPrepared);
	if (sqlite3_finalize(statementPrepared)) {
		[self logError:statement];
	}
}

+ (NSInteger)selectIntExpression:(NSString*)statement {
	sqlite3_stmt* statementPrepared;
	sqlite3_prepare_v2 (sqlDb, [statement UTF8String], -1, &statementPrepared, NULL);
	sqlite3_step(statementPrepared);
	int result = sqlite3_column_int(statementPrepared, 0);
	if (sqlite3_finalize(statementPrepared)) {
		[self logError:statement];
	}
	return result;	
}

+ (NSString*)selectTextColumn:(NSString*)statement {
	sqlite3_stmt* statementPrepared;
	sqlite3_prepare_v2 (sqlDb, [statement UTF8String], -1, &statementPrepared, NULL);
	sqlite3_step(statementPrepared);
    NSString* result = nil;
    char* textVal = (char*)sqlite3_column_text(statementPrepared, 0);
    if (textVal != nil) {		
        result = [NSString stringWithUTF8String:textVal];
    }
	if (sqlite3_finalize(statementPrepared)) {
		[self logError:statement];
	}
	return result;	
}

+ (NSArray*)selectAllTextColumn:(NSString*)statement {
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:10];
	sqlite3_stmt* statementPrepared;
	sqlite3_prepare_v2 (sqlDb, [statement UTF8String], -1, &statementPrepared, NULL);
    while (sqlite3_step(statementPrepared) == SQLITE_ROW) {
        char* textVal = (char*)sqlite3_column_text(statementPrepared, 0);
        [result addObject:[NSString stringWithUTF8String:textVal]];
    }
	if (sqlite3_finalize(statementPrepared)) {
		[self logError:statement];
	}
    return result;
}

+ (void)selectForModel:(id<DbiDelegate>)model withStatement:(NSString*)statement andOutputTo:(id)result {
	sqlite3_stmt* statementPrepared;
	sqlite3_prepare_v2 (sqlDb, [statement UTF8String], -1, &statementPrepared, NULL);
	sqlite3_step(statementPrepared);
	if ([model respondsToSelector:@selector(collectFromResult:andOutputTo:)] ) {
		[model collectFromResult:statementPrepared andOutputTo:result];
	} else {
		NSLog(@"Model does not implement respondsToSelector:andOtputTo:");
	}
	if (sqlite3_finalize(statementPrepared)) {
		[self logError:statement];
	}
}

+ (void)selectAllForModel:(id<DbiDelegate>)model withStatement:(NSString*)statement andOutputTo:(NSMutableArray*)results {
	sqlite3_stmt* statementPrepared;
	sqlite3_prepare_v2 (sqlDb, [statement UTF8String], -1, &statementPrepared, NULL);
	if ([model respondsToSelector:@selector(collectAllFromResult:andOutputTo:)]) {
		while (sqlite3_step(statementPrepared) == SQLITE_ROW) {
			[model collectAllFromResult:statementPrepared andOutputTo:results];
		}
	} else {
		NSLog(@"Model does not implement collecAllFromResult:andOtputTo:");
	}
	if (sqlite3_finalize(statementPrepared)) {
		[self logError:statement];
	}
}

+ (void)logError:(NSString*)statement {
	NSLog(@"SQL STATEMENT FAILED: %@", statement);
}


@end
