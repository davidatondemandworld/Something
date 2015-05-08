//
//  SqliteDataReader.m
//  RSS
//
//  Created by Andy Tung on 12-8-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "SqliteDataReader.h"


@implementation SqliteDataReader

- (id)initWithStatement:(sqlite3_stmt *)aStatement{
    self=[super init];
    if (self) {
        statement=aStatement;
    }
    return self;
}

- (BOOL)read{
    return sqlite3_step(statement)==SQLITE_ROW;
}

- (int)integerValueForColumnIndex:(NSUInteger)columnIndex{
    int value=sqlite3_column_int(statement, columnIndex);
    return value;
}

- (double)doubleValueForColumnIndex:(NSUInteger)columnIndex{
    double value=sqlite3_column_double(statement, columnIndex);
    return value;
}

- (NSString *)stringValueForColumnIndex:(NSUInteger)columnIndex{
    const unsigned char *value=sqlite3_column_text(statement, columnIndex);
    return [NSString stringWithCString:(const char *)value encoding:NSUTF8StringEncoding];
}

- (void)close{
    sqlite3_finalize(statement);
}

@end
