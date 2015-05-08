//
//  ChannelSourceService.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-18.
//
//

#import "ChannelSourceService.h"
#import "ChannelSource.h"

@implementation ChannelSourceService

+(NSArray *)downloadChannelSources{
    NSString *filename=[[NSBundle mainBundle] pathForResource:@"channelsources" ofType:@"plist"];   
    NSArray *array=[NSArray arrayWithContentsOfFile:filename];
    
    NSMutableArray *array2=[NSMutableArray arrayWithCapacity:[array count]];
    ChannelSource *item=nil;
    for (NSDictionary *dict in array) {
        item=[[ChannelSource alloc] init];
        item.name=[dict objectForKey:@"name"];
        item.url=[dict objectForKey:@"data_url"];
        item.className=[dict objectForKey:@"class_name"];
        item.siteUrl=[dict objectForKey:@"site_url"];
        [array2 addObject:item];
        [item release];
    }
    
    return array2;
}

@end
