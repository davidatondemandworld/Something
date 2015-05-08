//
//  RSSDatabase.h
//  RSS
//
//  Created by Andy Tung on 12-8-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteDatabase.h"

@interface RSSDatabase : NSObject {
    SqliteDatabase *sqliteDatabase;    
}
//如果数据库文件不存在，则创建并初始化数据库
+ (void) createDatabaseIfNotExists;
//获取数据库文件路径
+ (NSString *) filename;
//共享的数据库实例对象
+ (RSSDatabase *) sharedDatabase;

@end