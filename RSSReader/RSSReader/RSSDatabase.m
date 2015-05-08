//
//  RSSDatabase.m
//  RSS
//
//  Created by Andy Tung on 12-8-9.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "RSSDatabase.h"
#import "SqliteDatabase.h"

static RSSDatabase *staticRSSDatabase=nil;
static NSString *staticFilename=nil;

@implementation RSSDatabase

+(void)createDatabaseIfNotExists{
        NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:[RSSDatabase filename]]) {
        return;
    } 
    
    //组装数据库初始化SQL语句
    NSMutableString *init_sqls=[NSMutableString stringWithCapacity:1024];
    //创建表SQL语句
    [init_sqls appendFormat:@"CREATE TABLE Categories(Id integer primary key,Name text,OrderIndex integer);"];    
    [init_sqls appendFormat:@"CREATE TABLE Channels(Id integer primary key,CategoryId integer,Title text,Url text,Description text);"];
    [init_sqls appendFormat:@"CREATE TABLE Favorites(Id integer primary key,Title text,Url text);"];
    
    //插入Categories表默认数据 SQL语句
    [init_sqls appendFormat:@"INSERT INTO Categories(Name,OrderIndex) VALUES('常用频道',0);"];
    [init_sqls appendFormat:@"INSERT INTO Categories(Name,OrderIndex) VALUES('体育新闻',1);"];
    [init_sqls appendFormat:@"INSERT INTO Categories(Name,OrderIndex) VALUES('娱乐新闻',2);"];    
    
    SqliteDatabase *db=[[SqliteDatabase alloc] initWithFilename:[RSSDatabase filename]];        
    [db executeNonQuery:init_sqls error:nil];    
    [db release]; 
}

+ (NSString *)filename{
    if (staticFilename==nil) { 
        staticFilename=[[NSString alloc] initWithFormat:@"%@/documents/rss.sqlite",NSHomeDirectory()];
        //staticFilename=@"/tmp/rss.sqlite";
        NSLog(@"%@",staticFilename);
    }
    return staticFilename;
}

+ (RSSDatabase *)sharedDatabase{
    if(staticRSSDatabase==nil){
        staticRSSDatabase=[[RSSDatabase alloc] init];      
    }
    return staticRSSDatabase;
}

- (id)init{
    self=[super init];
    if (self) {
        sqliteDatabase=[[SqliteDatabase alloc] initWithFilename:[RSSDatabase filename]];
    }
    return self;
}

@end
