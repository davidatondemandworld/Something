//
//  DetailChannel.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-23.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "DetailChannel.h"

@implementation DetailChannel
@synthesize title,pubDate,_description,link;
@synthesize detailVisible = _detailVisible;
-(NSString *)description
{
    return [NSString stringWithFormat:@"title:%@,pubDate:%@,description:%@,link:%@",title,pubDate,_description,link];
}


@end
