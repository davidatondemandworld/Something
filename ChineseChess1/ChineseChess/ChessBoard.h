//
//  ChessBoard.h
//  ObjC_Chess
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
@class Chessman;
@protocol ChessboardDelegate;

@interface ChessBoard : NSObject<UIAlertViewDelegate>{
    id<ChessboardDelegate> __unsafe_unretained _delegate;
    Chessman *_items[10][9];
    OffensiveType _currentOffensive;
    Chessman *__unsafe_unretained _selectedChessman;
    UIAlertView *reset;
}

@property (nonatomic,unsafe_unretained) id<ChessboardDelegate> delegate;
@property (unsafe_unretained, readonly) Chessman *selectedChessman;
@property (readonly) OffensiveType currentOffensive;
@property (nonatomic,strong) NSMutableArray *itemArray;

- (void) reset;

- (Chessman *) chessmanAtPosition:(Position) pos;

- (void) setSelectedChessmanAtPosition:(Position) pos;
- (void) moveSelectedChessmanTo:(Position) target;

@end

@protocol ChessboardDelegate <NSObject>

- (void) chessboard:(ChessBoard *)chessboard didSelectChessman:(Chessman *) selectedChessman deselectChessman:(Chessman *) deselectedChessman;
- (void) chessboard:(ChessBoard *)chessboard moveChessman:(Chessman *)chessman from:(Position) from to:(Position) target killedChessman:(Chessman *)killedChessman;

@end
