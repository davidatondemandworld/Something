//
//  ChannelsInfo.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-18.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "ChannelsInfo.h"

@implementation ChannelsInfo
@synthesize _ID,_CategoryID,_Title,_Description,_Url;

-(NSString *)description
{
    return [NSString stringWithFormat:@"ID:%i,CategoryID:%i,Title:%@,URL:%@,Description:%@",_ID,_CategoryID,_Title,_Url,_Description];
}

@end
