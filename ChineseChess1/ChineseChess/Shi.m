//
//  Shi.m
//  ChineseChess
//
//  Created by Bourbon on 13-10-24.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "Shi.h"

@implementation Shi
- (id)initWithOffensiveType:(OffensiveType)offensiveType
{
    if (self=[super initWithOffensiveType:offensiveType])
    {
        _name=@"士";
    }
    return self;
}
- (BOOL)canMoveTo:(Position)target{
    if ([super canMoveTo:target]) {
        int stepX=abs(target.x-_position.x);
        int stepY=abs(target.y-_position.y);
        
        BOOL Y = (target.y>=0&&target.y<=2) || (target.y>=7&&target.y<=9);
        
        if ((stepX==1&&stepY==1)&&(target.x>=3&&target.x<=5)&&Y)
        {
            return YES;
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不是斜线" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return NO;
}
@end
