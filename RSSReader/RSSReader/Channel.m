//
//  Channel.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Channel.h"
#import "Utilities.h"
#import "RSSFormatAnalyzer.h"
#import "ChannelParsing.h"
#import "RSSChannelParser.h"
#import "FeedChannelParser.h"

@implementation Channel

- (void)dealloc{
    [_title release];
    [_url release];
    [_pubDate release];
    [super dealloc];
}

@synthesize title=_title,url=_url,pubDate=_pubDate,categoryId=_categoryId,ID=_ID;
@synthesize desc=_desc;

-(NSArray *)loadItems:(NSError **)error{
    NSError *innerError=nil;
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:_url]];
    NSData *data=[Utility sendSynchronousRequest:request error:&innerError];
    if (innerError!=nil) {
        if (error!=nil) {
            *error=innerError;
        }
        return nil;
    }
    
    RSSFormatAnalyzer *analyzer=[[RSSFormatAnalyzer alloc] init];
    RSSFormat format=[analyzer analyze:data];
    [analyzer release];
    
    if (format==kUnknown) {
        if (error!=nil) {
            *error=[NSError errorWithDomain:PARSING_ERROR_DOMAIN code:kUnknownRSSFormat errmsg:@"无效的RSS内容格式" innerError:nil];
        }
        return nil;
    }
    
    id<ChannelParsing> parser=nil;
    if (format==kRSS) {
        parser=[[RSSChannelParser alloc] init];
    }
    else if(format==kFeed){
        parser=[[FeedChannelParser alloc] init];
    }
    
    NSDictionary *dict=[parser parseData:data error:&innerError];
    if (innerError!=nil) {
        if (error!=nil) {
            *error=[NSError errorWithDomain:PARSING_ERROR_DOMAIN code:kParseRSSXmlFailed errmsg:@"频道解析失败" innerError:innerError];
        }
        return nil;
    }
    
    self.pubDate=[dict objectForKey:kPubDate];
    return [dict objectForKey:kArticles];    
}

- (NSString *)description{
    return [NSString stringWithFormat:@"Channel\ntitle:%@\nxmlUrl:%@\npubDate:%@",self.title,self.url,self.pubDate];
}

@end
