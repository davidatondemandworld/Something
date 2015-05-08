//
//  RSSDatabase+RSSProvider.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-18.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "RSSDatabase.h"
#import "CategoryInfo.h"
#import "ChannelsInfo.h"
#import "Articles.h"
#import "Channel.h"
@implementation RSSDatabase (RSSProvider)

-(int)addCategory:(CategoryInfo *)aCategory error:(NSError **)error
{ 
    NSString *sql = [NSString stringWithFormat:@"insert into Category(Name)values('%@');",aCategory._Name];
    int lastRowId;
    int rc = [sqliteDatabase executeNonQuery:sql outputLastInsertRowId:&lastRowId error:error];
    if(rc == SQLITE_OK)
    {
        aCategory._ID = lastRowId;
    }
    
    return rc;
}
-(int)updateCategory:(CategoryInfo *)aCategory to:(CategoryInfo *)bCategory error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"update Category set Name='%@' where Id=%i;",bCategory._Name,aCategory._ID];
    
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}
-(int)deleteCategory:(CategoryInfo *)aCategory error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"delete from Category where Name='%@'",aCategory._Name];
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}


-(int)addChannel:(ChannelsInfo *)aChannel error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"insert into Channels(CategoryID,Title,URL,Description)values(%i,'%@','%@','%@');",aChannel._CategoryID,aChannel._Title,aChannel._Url,aChannel._Description];
    int lastRowId;
    int rc = [sqliteDatabase executeNonQuery:sql outputLastInsertRowId:&lastRowId error:error];
    if(rc == SQLITE_OK)
    {
        aChannel._ID = lastRowId;
    }
    return rc;
}
-(int)deleteChannel:(ChannelsInfo *)aChannel error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"delete from Channels where ID=%i;",aChannel._ID];
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}

-(int)addArticle:(Articles *)aArticle error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"insert into Articles(Title,URL,Description)values('%@','%@','%@');",aArticle._Title,aArticle._URL,aArticle._Description];
    int lastRowId;
    int rc = [sqliteDatabase executeNonQuery:sql outputLastInsertRowId:&lastRowId error:error];
    if(rc == SQLITE_OK)
    {
        aArticle._ID = lastRowId;
    }
    return rc;
}
-(int)deleteArticle:(Articles *)aArticle error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"delete from Articles where ID=%i;",aArticle._ID];
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}

-(NSArray *)selectAllCategory
{
    NSString *sql = @"select *from Category";
    [sqliteDatabase open];
    SqliteDataReader *dr = [sqliteDatabase executeQuery:sql];
    NSMutableArray *array=[NSMutableArray array];
    if (dr!=nil){
        while ([dr read]) {
            CategoryInfo *category=[[CategoryInfo alloc] init];
            category._ID = [dr integerValueForColumnIndex:0];
            category._Name=[dr stringValueForColumnIndex:1];
            [array addObject:category];
        }
        [dr close];
    }
    [sqliteDatabase close];
    
    return array;
}
-(NSArray *)selectAllChannels
{
    NSString *sql = @"select *from Channels";
    [sqliteDatabase open];
    SqliteDataReader *dr = [sqliteDatabase executeQuery:sql];
    NSMutableArray *array=[NSMutableArray array];
    if (dr!=nil){
        while ([dr read]) {
            ChannelsInfo *channel=[[ChannelsInfo alloc] init];
            channel._ID = [dr integerValueForColumnIndex:0];
            channel._CategoryID=[dr integerValueForColumnIndex:1];
            channel._Title = [dr stringValueForColumnIndex:2];
            channel._Url = [dr stringValueForColumnIndex:3];
            channel._Description = [dr stringValueForColumnIndex:4];
            [array addObject:channel];
        }
        [dr close];
    }
    [sqliteDatabase close];
    
    return array;
}
-(NSArray *)selectAllArticles
{
    NSString *sql = @"select *from Articles";
    [sqliteDatabase open];
    SqliteDataReader *dr = [sqliteDatabase executeQuery:sql];
    NSMutableArray *array=[NSMutableArray array];
    if (dr!=nil){
        while ([dr read]) {
            Articles *article=[[Articles alloc] init];
            article._ID = [dr integerValueForColumnIndex:0];
            article._Title =[dr stringValueForColumnIndex:1];
            article._URL = [dr stringValueForColumnIndex:2];
            article._Description = [dr stringValueForColumnIndex:3];
            [array addObject:article];
        }
        [dr close];
    }
    [sqliteDatabase close];
    
    return array;
}

-(NSMutableArray *)selectChannelByCategoryId:(int)categoryId
{
    ChannelsInfo *channel=nil;
    
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM channels WHERE CategoryId=%i",categoryId];
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (dr!=nil) {
        while ([dr read]) {
        channel=[[ChannelsInfo alloc] init];
        channel._ID = [dr integerValueForColumnIndex:0];
        channel._CategoryID = [dr integerValueForColumnIndex:1];
        channel._Title = [dr stringValueForColumnIndex:2];
        channel._Url = [dr stringValueForColumnIndex:3];
        channel._Description = [dr stringValueForColumnIndex:4];
        [array addObject:channel];
        }
        [dr close];
    }
    [sqliteDatabase close];
    
    return array;
}
-(NSMutableArray *)selectChannelByTitle:(NSString *) title
{
    ChannelsInfo *channel=nil;
    
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM channels WHERE title = '%@';",title];
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (dr!=nil) {
        while ([dr read]) {
            channel=[[ChannelsInfo alloc] init];
            channel._ID = [dr integerValueForColumnIndex:0];
            channel._CategoryID = [dr integerValueForColumnIndex:1];
            channel._Title = [dr stringValueForColumnIndex:2];
            channel._Url = [dr stringValueForColumnIndex:3];
            channel._Description = [dr stringValueForColumnIndex:4];
            [array addObject:channel];
        }
        [dr close];
    }
    [sqliteDatabase close];
    
    return array;
}
-(NSMutableArray *)selectArticleByTitle:(NSString *)title
{
    Articles *article=nil;
    
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM Articles WHERE title = '%@';",title];
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
    
    NSMutableArray *array = [NSMutableArray array];
    
    if (dr!=nil) {
        while ([dr read]) {            
            article = [[Articles alloc] init];
            article._ID = [dr integerValueForColumnIndex:0];
            article._Title = [dr stringValueForColumnIndex:1];
            article._URL = [dr stringValueForColumnIndex:2];
            article._Description = [dr stringValueForColumnIndex:3];
            [array addObject:article];
        }
        [dr close];
    }
    [sqliteDatabase close];
    
    return array;
}

@end
