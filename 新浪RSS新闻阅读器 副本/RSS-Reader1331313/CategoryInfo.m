//
//  CategoryInfo.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-18.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "CategoryInfo.h"

@implementation CategoryInfo
@synthesize _ID,_Name;

-(NSString *)description
{
    return [NSString stringWithFormat:@"ID:%i,Name:%@",_ID,_Name];
}
@end
