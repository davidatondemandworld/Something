//
//  SqliteDataReader.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-3.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
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

- (int)integerValueForColumnIndex:(int)columnIndex{
    int value=sqlite3_column_int(statement, columnIndex);
    return value;
}

- (double)doubleValueForColumnIndex:(int)columnIndex{
    double value=sqlite3_column_double(statement, columnIndex);
    return value;
}

- (NSString *)stringValueForColumnIndex:(int)columnIndex{
    const unsigned char *value=sqlite3_column_text(statement, columnIndex);
    return [NSString stringWithCString:(const char *)value encoding:NSUTF8StringEncoding];
}

- (void)close{
    sqlite3_finalize(statement);
}

@end

