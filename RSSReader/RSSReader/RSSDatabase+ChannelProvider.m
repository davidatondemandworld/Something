//
//  RSSDatabase+ChannelProvider.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-17.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RSSDatabase+ChannelProvider.h"
#import "Channel.h"

@implementation RSSDatabase (ChannelProvider)

- (int)insertChannel:(Channel *)channel error:(NSError **)error{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO Channels(CategoryId,Title,Url,Description) VALUES(%i,'%@','%@','%@')",channel.categoryId,channel.title,channel.url,channel.description];
    int lastRowId;
    int rc=[sqliteDatabase executeNonQuery:sql outputLastInsertRowId:&lastRowId error:error];
    if (rc==SQLITE_OK) {
        channel.ID=lastRowId;
    }
    return rc;
}

- (int)updateChannel:(Channel *)channel error:(NSError **)error{
    NSString *sql=[NSString stringWithFormat:@"UPDATE Channels SET CategoryId=%i,Title='%@',Url='%@',Description='%@' WHERE Id=%i",channel.categoryId,channel.title,channel.url,channel.description,channel.ID];
    int rc=[sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}

- (int)deleteChannel:(Channel *)channel error:(NSError **)error{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM Channels WHERE Id=%i",channel.ID];
    int rc=[sqliteDatabase executeNonQuery:sql error:error];
    return rc;

}

- (Channel *)selectChannelById:(int)channelId{
    NSString *sql=[NSString stringWithFormat:@"SELECT Id,CategoryId,Title,Url,Description FROM Channels WHERE Id=%i",channelId];
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
    
    Channel *item=nil;
    if (dr!=nil){
        if ([dr read]) {
            item=[[[Channel alloc] init] autorelease];
            item.ID=channelId;
            item.categoryId=[dr integerValueForColumnIndex:1];
            item.title=[dr stringValueForColumnIndex:2];
            item.url=[dr stringValueForColumnIndex:3];
            item.desc=[dr stringValueForColumnIndex:4];
        }
        [dr close];
    }
    
    [sqliteDatabase close];
    return item;
}

- (Channel *)selectChannelByURLString:(NSString *)urlString{
    NSString *sql=[NSString stringWithFormat:@"SELECT Id,CategoryId,Title,Url,Description FROM Channels WHERE Url='%@'",urlString];
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
    
    Channel *item=nil;
    if (dr!=nil){
        if ([dr read]) {
            item=[[[Channel alloc] init] autorelease];
            item.ID=[dr integerValueForColumnIndex:0];
            item.categoryId=[dr integerValueForColumnIndex:1];
            item.title=[dr stringValueForColumnIndex:2];
            item.url=[dr stringValueForColumnIndex:3];
            item.desc=[dr stringValueForColumnIndex:4];
        }
        [dr close];
    }
    
    [sqliteDatabase close];
    return item;
}

- (NSArray *)selectChannelsByCategoryId:(int)categoryId{
    NSString *sql=[NSString stringWithFormat:@"SELECT Id,CategoryId,Title,Url,Description FROM Channels WHERE CategoryId=%i",categoryId];
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
    
    NSMutableArray *items=[NSMutableArray arrayWithCapacity:16];
    Channel *item=nil;
    if (dr!=nil){
        while ([dr read]) {
            item=[[[Channel alloc] init] autorelease];
            item.ID=[dr integerValueForColumnIndex:0];
            item.categoryId=[dr integerValueForColumnIndex:1];
            item.title=[dr stringValueForColumnIndex:2];
            item.url=[dr stringValueForColumnIndex:3];
            item.desc=[dr stringValueForColumnIndex:4];
            [items addObject:item];
        }
        [dr close];
    }
    
    [sqliteDatabase close];
    return items;
}

@end
