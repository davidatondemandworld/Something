//
//  Jiang.m
//  ChineseChess
//
//  Created by Bourbon on 13-10-24.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "Jiang.h"

@implementation Jiang
- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if (self=[super initWithOffensiveType:offensiveType]) {
        _name=@"将";
    }
    return self;
}
- (BOOL)canMoveTo:(Position)target{
    if ([super canMoveTo:target]) {
        int stepX=abs(target.x-_position.x);
        int stepY=abs(target.y-_position.y);
        
        BOOL X = (target.x>=3&&target.x<=5);
        BOOL Y = (target.y>=0 && target.y <=2)||(target.y>=7 && target.y <= 9);
        BOOL Z = (stepX == 1 && stepY == 0) || (stepX == 0 && stepY == 1);
        
        if (Z && X && Y) {
            return YES;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不能出田字且要走直线" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return NO;
}
@end
