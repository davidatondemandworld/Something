//
//  Chessman.m
//  ObjC_Chess
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "Chessman.h"
#import "ChessBoard.h"

@implementation Chessman

@synthesize offensiveType=_offensiveType;
@synthesize name=_name;
@synthesize position=_position;
@synthesize chessboard=_chessboard;

- (id)initWithOffensiveType:(OffensiveType)offensiveType{
    if(self=[super init]){
        _offensiveType=offensiveType;
    }
    return self;
}

- (BOOL)canMoveTo:(Position)target{
    return YES;
}

- (void)moveTo:(Position)target{
    _position = target;    
}
-(NSString *)description
{
    return [NSString stringWithFormat:@"%@:(X:%d,Y:%d)",self.name,self.position.x,self.position.y];
}
@end
