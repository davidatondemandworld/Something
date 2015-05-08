//
//  BoardView.h
//  ChineseChess
//
//  Created by 深圳鲲鹏 on 13-5-21.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
@class ChessmanView;
@class FlagView;
@protocol ChessboardViewDelegate;

@interface ChessboardView : UIView{
    id<ChessboardViewDelegate> __unsafe_unretained _delegate;
    ChessmanView *_items[10][9];
    CGSize _gridSize;//棋盘格子的尺寸
    CGSize _offset;//棋盘{0,0}坐标的偏移尺寸
    CGSize _flagSize;//棋子标志线的尺寸
    float _flagPadding;//棋子标志线与棋盘线的填充尺寸
    UIColor *_lineColor;//棋盘线的颜色
    float _lineWidth;//棋盘线的宽度
    
    FlagView *_flagView;
}

@property (nonatomic,unsafe_unretained) id<ChessboardViewDelegate> delegate;
@property (nonatomic,strong) UIColor *lineColor;
@property (readonly) CGSize gridSize;

- (void) loadData;
//选中某个棋子
- (void) selectChessmanViewAtPosition:(Position) pos animated:(BOOL)animated;
//取消某个棋子的选择状态
- (void) deselectChessmanViewAtPosition:(Position) pos animated:(BOOL)animated;
//移动棋子
- (void) moveChessmanViewAtPosition:(Position) from to:(Position) target animated:(BOOL)animated;

@end
// delegate 走棋
@protocol ChessboardViewDelegate <NSObject>
@required
- (ChessmanView *) chessboardView:(ChessboardView *) chessboardView chessmanViewAtPosition:(Position) pos;
- (void) chessboardView:(ChessboardView *) chessboardView touchAtPosition:(Position) pos;
@end
