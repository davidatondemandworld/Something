//
//  Articles.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-18.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "Articles.h"

@implementation Articles
@synthesize _ID,_Title,_URL,_Description;

-(NSString *)description
{
    return [NSString stringWithFormat:@"ID:%i,Titlt:%@,URL:%@,Description:%@",_ID,_Title,_URL,_Description];
}

@end
