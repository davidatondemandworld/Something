//
//  Car.m
//  ChineseChess
//
//  Created by Bourbon on 13-10-24.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "Car.h"

@implementation Car

- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if (self=[super initWithOffensiveType:offensiveType]) {
        _name=@"车";
    }
    return self;
}
- (BOOL)canMoveTo:(Position)target{
    if ([super canMoveTo:target]) {
        int stepX=abs(target.x-_position.x);
        int stepY=abs(target.y-_position.y);
        if ((stepX==0&&stepY!=0)||(stepX!=0&&stepY==0)) {
            return YES;
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"不是直线" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return NO;
        }
    }
    return NO;
}

@end
