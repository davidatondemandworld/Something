//
//  Bing.m
//  ChineseChess
//
//  Created by Bourbon on 13-10-24.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "Bing.h"
#import "Common.h"

@implementation Bing
- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if (self=[super initWithOffensiveType:offensiveType]) {
        _name=@"兵";
    }
    return self;
}
- (BOOL)canMoveTo:(Position)target{
    if ([super canMoveTo:target]) {
        int stepX=abs(target.x-_position.x);
        
        if (self.offensiveType == kRed)
        {
            if (_position.y >= 5)
            {
                if ((_position.y - target.y == 1)&&(_position.x == target.x))
                {
                    return YES;
                }
                else
                {
                    [self showAlert];
                }
            }
            else if (_position.y <=4)
            {
                if (((_position.y - target.y == 1)&&(_position.x == target.x))||((_position.y == target.y )&&(stepX == 1)))
                {
                    return YES;
                }
                else
                {
                    [self showAlert];
                }
            }
        }
        else if (self.offensiveType == kBlack)
        {
            if (_position.y <= 4)
            {
                if ((target.y - _position.y== 1)&&(_position.x == target.x))
                {
                    return YES;
                }
                else
                {
                    [self showAlert];
                }
            }
            else if (_position.y >=5)
            {
                if (((target.y - _position.y== 1)&&(_position.x == target.x))||((_position.y == target.y )&&(stepX == 1)))
                {
                    return YES;
                }
                else
                {
                    [self showAlert];
                }
            }
        }
        else
        {
            [self showAlert];
            return NO;
        }
    }
    return NO;
}
-(void)showAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"在过河前只能向前走，且只能走直线" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}
@end
