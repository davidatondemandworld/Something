//
//  RSSTestDatabase.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-19.
//
//

#import "RSSTestDatabase.h"


static NSString *filename=@"/tmp/rss.sqlite";

@implementation RSSTestDatabase

+(void)createTestDatabase{
    //staticFilename=@"/tmp/rss.sqlite";
    //组装数据库初始化SQL语句
    NSMutableString *init_sqls=[NSMutableString stringWithCapacity:1024];
    //创建表SQL语句
    [init_sqls appendFormat:@"CREATE TABLE Categories(Id integer primary key,Name text,OrderIndex integer);"];
    [init_sqls appendFormat:@"CREATE TABLE Channels(Id integer primary key,CategoryId integer,Title text,Url text,Description text);"];
    [init_sqls appendFormat:@"CREATE TABLE Favorites(Id integer primary key,Title text,Url text);"];
    
    //插入Categories表测试数据 SQL语句
    [init_sqls appendFormat:@"INSERT INTO Categories(Name,OrderIndex) VALUES('常用频道',0);"];
    [init_sqls appendFormat:@"INSERT INTO Categories(Name,OrderIndex) VALUES('体育新闻',1);"];
    [init_sqls appendFormat:@"INSERT INTO Categories(Name,OrderIndex) VALUES('娱乐新闻',2);"];
    //插入Channels测试数据 SQL语句
    [init_sqls appendFormat:@"INSERT INTO Channels(CategoryId,Title,Url,Description) VALUES(1,'足球','http://rss.sina.con.cn/football.xml','足球');"];
    [init_sqls appendFormat:@"INSERT INTO Channels(CategoryId,Title,Url,Description) VALUES(1,'篮球','http://rss.sina.con.cn/basketball.xml','篮球');"];
    [init_sqls appendFormat:@"INSERT INTO Channels(CategoryId,Title,Url,Description) VALUES(2,'最新专辑','http://rss.sina.con.cn/music.xml','最新专辑');"];
    
    SqliteDatabase *db=[[SqliteDatabase alloc] initWithFilename:filename];
    [db executeNonQuery:init_sqls error:nil];
    [db release];
}

+ (void)removeTestDatabase{
    [[NSFileManager defaultManager] removeItemAtPath:filename error:nil];
}

+ (NSString *)filename{
    return filename;
}

@end
