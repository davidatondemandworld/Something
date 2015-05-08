//
//  ChannelManager.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-18.
//
//

#import <Foundation/Foundation.h>
@class Channel;
@class RSSDatabase;

@interface ChannelManager : NSObject{
    RSSDatabase *db;
}

+(ChannelManager *) defaultManager;

- (NSArray *) channelsByCategoryId:(int) categoryId;
- (int) saveChannel:(Channel *) channel old:(Channel *) old  error:(NSError **)error;
- (int) deleteChannel:(Channel *) channel error:(NSError **)error;

- (void)dispose;

@end
