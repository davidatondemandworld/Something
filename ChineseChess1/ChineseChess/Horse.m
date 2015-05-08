//
//  Horse.m
//  ObjC_Chess
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "Horse.h"

@implementation Horse

- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if (self=[super initWithOffensiveType:offensiveType]) {
        _name=@"马";
    }
    return self;
}

- (BOOL)canMoveTo:(Position)target{
    if ([super canMoveTo:target]) {
        int stepX=abs(target.x-_position.x);
        int stepY=abs(target.y-_position.y);
        if ((stepX==1&&stepY==2)||(stepX==2&&stepY==1)) {
            return YES;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不是日字形" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return NO;
}

@end
