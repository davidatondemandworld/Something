//
//  Database.m
//  TCPListner
//
//  Created by 深圳鲲鹏 on 13-9-29.
//
//

#import "Database.h"
static Database *staticDatabase;

@implementation Database
+(void)createDatabaseIfNotExists
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:[Database filename]])
    {
        return;
    }
    NSMutableString *init_sqls = [NSMutableString stringWithCapacity:1024];
    [init_sqls appendFormat:@"create table Login(ID integer primary key autoincrement,Name text not null,Password text not null);"];
    
    [init_sqls appendFormat:@"insert into Login(Name,Password)values('63A9F0EA7BB98050796B649E85481845','63A9F0EA7BB98050796B649E85481845');"];

    SqliteDatabase *db = [[SqliteDatabase alloc] initWithFilename:[Database filename]];
    [db executeNonQuery:init_sqls error:nil];
}

+(NSString *)filename
{
    NSString *str = [[NSString alloc] initWithFormat:@"%@/login.sqlite",NSHomeDirectory()];
    return str;
}

+(Database *)sharedDatabase
{
    if(staticDatabase == nil)
    {
        staticDatabase = [[Database alloc] init];
    }
    return staticDatabase;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        sqliteDatabase = [[SqliteDatabase alloc] initWithFilename:[Database filename]];
    }
    return self;
}
@end
