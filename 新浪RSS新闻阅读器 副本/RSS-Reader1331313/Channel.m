//
//  Channel.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-23.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "Channel.h"

@implementation Channel
@synthesize title,url;

-(NSString *)description
{
    return [NSString stringWithFormat:@"title:%@,url:%@",title,url];
}


@end
