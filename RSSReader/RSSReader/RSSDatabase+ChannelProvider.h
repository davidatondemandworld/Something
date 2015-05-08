//
//  RSSDatabase+ChannelProvider.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-17.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RSSDatabase.h"
@class Channel;

@interface RSSDatabase (ChannelProvider)

- (int) insertChannel:(Channel *) channel error:(NSError **)error;
- (int) updateChannel:(Channel *) channel error:(NSError **)error;
- (int) deleteChannel:(Channel *) channel error:(NSError **)error;

- (NSArray *) selectChannelsByCategoryId:(int) categoryId;
- (Channel *) selectChannelById:(int) channelId;
- (Channel *) selectChannelByURLString:(NSString *) urlString;

@end
