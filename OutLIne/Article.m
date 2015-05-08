//
//  Article.m
//  OutLIne
//
//  Created by 深圳鲲鹏 on 13-9-17.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "Article.h"

@implementation Article
@synthesize _title,_link,_pubDate,_description;

-(NSString *)description
{
    return [NSString stringWithFormat:@"title:%@,link:%@,pubDate:%@,description:%@",_title,_link,_pubDate,_description];
}

@end
