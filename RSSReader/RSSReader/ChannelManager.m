//
//  ChannelManager.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-18.
//
//

#import "ChannelManager.h"
#import "Channel.h"
#import "RSSDatabase+ChannelProvider.h"
#import "Utilities.h"

#define CHANNELMANAGER_ERROR_DOMAIN @"CHANNELMANAGER_ERROR_DOMAIN"
#define CHANNELMANAGER_ERROR_DUPLICATED_URL 1101
#define CHANNELMANAGER_ERROR_DUPLICATED_URL_MSG @"已存在相同的订阅频道"

static ChannelManager *staticInstance=nil;

@implementation ChannelManager

- (id)init{
    if (self=[super init]) {
        db=[RSSDatabase sharedDatabase];
    }
    return self;
}

+(id)defaultManager{
    if (staticInstance==nil) {
        staticInstance=[[[self class] alloc] init];
    }
    return staticInstance;
}

- (NSArray *)channelsByCategoryId:(int)categoryId{
    return [db selectChannelsByCategoryId:categoryId];
}

- (int)saveChannel:(Channel *)channel old:(Channel *)old error:(NSError **)error{
    int rc;
    Channel *item=[db selectChannelByURLString:channel.url];
    if (old!=nil) {
        if (item!=nil&&item.ID!=channel.ID) {
            if (error!=nil) {
                *error=[NSError errorWithDomain:CHANNELMANAGER_ERROR_DOMAIN  code:CHANNELMANAGER_ERROR_DUPLICATED_URL errmsg:CHANNELMANAGER_ERROR_DUPLICATED_URL_MSG innerError:nil];
            }
            return CHANNELMANAGER_ERROR_DUPLICATED_URL;
        }
        rc=[db updateChannel:channel error:error];
        if (rc==0) {
            old.title=channel.title;
            old.url=channel.url;
            old.categoryId=channel.categoryId;
            old.desc=channel.desc;
        }
    }
    else{
        if (item!=nil) {
            if (error!=nil) {
                *error=[NSError errorWithDomain:CHANNELMANAGER_ERROR_DOMAIN  code:CHANNELMANAGER_ERROR_DUPLICATED_URL errmsg:CHANNELMANAGER_ERROR_DUPLICATED_URL_MSG innerError:nil];
            }
            return CHANNELMANAGER_ERROR_DUPLICATED_URL;
        }
        
        rc=[[RSSDatabase sharedDatabase] insertChannel:channel error:error];        
    }
    return rc;
}

- (int)deleteChannel:(Channel *)channel error:(NSError **)error{
    int rc=[db deleteChannel:channel error:error];
    return rc;
}

- (void)dispose{
    
}

@end
