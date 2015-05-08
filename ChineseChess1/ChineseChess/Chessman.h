//
//  Chessman.h
//  ObjC_Chess
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
@class ChessBoard;

@interface Chessman : NSObject{
    NSString *__unsafe_unretained _name;
    Position _position;
    OffensiveType _offensiveType;
    ChessBoard *__unsafe_unretained _chessboard;
}
@property (readonly) OffensiveType offensiveType;
@property (unsafe_unretained, readonly) NSString *name;
@property (nonatomic,assign) Position position;
@property (nonatomic,unsafe_unretained) ChessBoard *chessboard;

- (id) initWithOffensiveType:(OffensiveType) offensiveType;

- (BOOL) canMoveTo:(Position) target ;
- (void) moveTo:(Position) target;

@end
