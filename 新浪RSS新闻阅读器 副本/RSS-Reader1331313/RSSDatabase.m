//
//  RSSDatabase.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-18.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "RSSDatabase.h"
#import "SqliteDatabase.h"

static RSSDatabase *staticRSSDatabase;

@implementation RSSDatabase
+(void)createDatabaseIfNotExists
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:[RSSDatabase filename]])
    {
        return;
    }
    NSMutableString *init_sqls = [NSMutableString stringWithCapacity:1024];
    [init_sqls appendFormat:@"create table Category(ID integer primary key autoincrement,Name text not null);"];
    [init_sqls appendFormat:@"create table Channels(ID integer primary key autoincrement,CategoryID integer not null,Title text not null,URl text not null,Description text not null);"];
    [init_sqls appendFormat:@"create table Articles(ID integer primary key autoincrement,Title text not null,URL text not null,Description text not null);"];
    
    [init_sqls appendFormat:@"insert into Category(Name)values('常用频道');"];
    [init_sqls appendFormat:@"insert into Category(Name)values('体育频道');"];
    [init_sqls appendFormat:@"insert into Category(Name)values('娱乐频道');"];
    
    SqliteDatabase *db = [[SqliteDatabase alloc] initWithFilename:[RSSDatabase filename]];
    [db executeNonQuery:init_sqls error:nil];
}

+(NSString *)filename
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@/Documents/rss.sqlite",NSHomeDirectory()];
    return str;
}

+(RSSDatabase *)sharedDatabase
{
    if(staticRSSDatabase == nil)
    {
        staticRSSDatabase = [[RSSDatabase alloc] init];
    }
    return staticRSSDatabase;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        sqliteDatabase = [[SqliteDatabase alloc] initWithFilename:[RSSDatabase filename]];
    }
    return self;
}
@end
