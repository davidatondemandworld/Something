//
//  Elephant.m
//  ObjC_Chess
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "Elephant.h"
#import "Common.h"

@implementation Elephant

- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if (self=[super initWithOffensiveType:offensiveType]) {
        _name=@"象";
    }
    return self;
}
- (BOOL)canMoveTo:(Position)target
{
    if ([super canMoveTo:target])
    {
        int stepX=abs(target.x-_position.x);
        int stepY=abs(target.y-_position.y);

        if (self.offensiveType == kBlack)
        {
            if ((target.y >=0 && target.y <=4)&&((stepX==2&&stepY==2)||(stepX==2&&stepY==2)))
            {
                return YES;
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不是田字形" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
        }
        else if (self.offensiveType == kRed)
        {
            if ((target.y >=5 && target.y <=9)&&((stepX==2&&stepY==2)||(stepX==2&&stepY==2)))
            {
                return YES;
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不是田字形" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
        }


    }
    return NO;
}
@end
