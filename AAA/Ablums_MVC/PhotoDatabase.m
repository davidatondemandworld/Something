//
//  PhotoDatabase.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-3.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "PhotoDatabase.h"
#import "SqliteDatabase.h"

static PhotoDatabase *staticPhotoDatabase;

@implementation PhotoDatabase
+(void)createDatabaseIfNotExists
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:[PhotoDatabase filename]])
    {
        return;
    }
    NSMutableString *init_sqls = [NSMutableString stringWithCapacity:1024];
    [init_sqls appendFormat:@"create table Photos(Id integer primary key autoincrement,Name text,CategoryId integer);"];
    [init_sqls appendFormat:@"create table Category(Id integer primary key autoincrement,Category text);"];

    for(int i=0; i<=17; i++)
    {
        [init_sqls appendFormat:@"insert into Photos(Name,CategoryId)values('%i.PNG',1);",i];
    }
    
    for(int i=6; i<=11; i++)
    {
        [init_sqls appendFormat:@"insert into Photos(Name,CategoryId)values('%i.PNG',2);",i];
    }
    
    for(int i=12; i<=17; i++)
    {
        [init_sqls appendFormat:@"insert into Photos(Name,CategoryId)values('%i.PNG',3);",i];
    }
    [init_sqls appendFormat:@"insert into Category(Category)values('存储的相册');"];
    [init_sqls appendFormat:@"insert into Category(Category)values('风景');"];
    [init_sqls appendFormat:@"insert into Category(Category)values('人物');"];
    
    SqliteDatabase *db = [[SqliteDatabase alloc] initWithFilename:[PhotoDatabase filename]];
    [db executeNonQuery:init_sqls error:nil];
    [db release];
}

+(NSString *)filename
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@/Documents/photo.sqlite",NSHomeDirectory()];
    return [str autorelease];
}

+(PhotoDatabase *)sharedDatabase
{
    if(staticPhotoDatabase == nil)
    {
        staticPhotoDatabase = [[PhotoDatabase alloc] init];
    }
    return staticPhotoDatabase;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        sqliteDatabase = [[SqliteDatabase alloc] initWithFilename:[PhotoDatabase filename]];
    }
    return self;
}
@end
