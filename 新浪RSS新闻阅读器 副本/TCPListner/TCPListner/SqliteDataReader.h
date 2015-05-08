//
//  SqliteDataReader.h
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-3.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SqliteDataReader : NSObject {
    sqlite3_stmt *statement;
}

- (id)initWithStatement:(sqlite3_stmt *)statement;
//移动读指针到下一行数据，返回NO表示已读到尾部
- (BOOL) read;
//读取对应列的整型值
- (int) integerValueForColumnIndex:(int) columnIndex;
//读取对应列的小数值
- (double) doubleValueForColumnIndex:(int) columnIndex;
//读取对应列的文本值
- (NSString *) stringValueForColumnIndex:(int) columnIndex;
//关闭并释放statement
- (void) close;

@end
