//
//  ChessBoard.m
//  ObjC_Chess
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "ChessBoard.h"
#import "Horse.h"
#import "Elephant.h"
#import "Car.h"
#import "Shi.h"
#import "Jiang.h"
#import "Bing.h"
#import "Pao.h"

@implementation ChessBoard

@synthesize delegate=_delegate;
@synthesize selectedChessman=_selectedChessman;
@synthesize currentOffensive=_currentOffensive;
@synthesize itemArray;

- (id)init{
    if (self=[super init]) {
        for (int y=0; y<10; y++) {
            for (int x=0; x<9; x++) {                
                _items[y][x]=nil;                      
            }
        }
    }
    return self;
}


- (void)reset
{
    [self set];
}

- (Chessman *)chessmanAtPosition:(Position)pos{
    return _items[pos.y][pos.x];
}

- (void)setSelectedChessmanAtPosition:(Position)pos
{
    int i=0;
    for (Chessman *info in itemArray)
    {
        if ([info.name isEqualToString:@"将"])
        {
            i++;
        }
    }
    if (i == 1)
    {
        reset = [[UIAlertView alloc] initWithTitle:@"游戏已结束" message:@"游戏已结束，确定重新开局?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [reset show];
    }
    
    Chessman *chessman=[self chessmanAtPosition:pos];
    
    if (chessman!=nil)
    {
        if (chessman.offensiveType==_currentOffensive)
        {
            if (_selectedChessman!=chessman)
            {
                Chessman *temp=_selectedChessman;
                _selectedChessman=chessman;
                if (_delegate!=nil)
                {
                    [_delegate chessboard:self didSelectChessman:_selectedChessman deselectChessman:temp]; 
                }
            }
        }
    }
}

- (void)moveSelectedChessmanTo:(Position)target
{
    for (Chessman *info in itemArray)
    {
        BOOL a = [info.name isEqualToString:@"将"];
        BOOL b = info.position.x == target.x ? YES:NO;
        BOOL c = info.position.y == target.y ? YES:NO;
        if (a && b && c)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"结束" message:@"结束" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }
    
    if (_selectedChessman!=nil)
    {
        if ([_selectedChessman canMoveTo:target])
        {
            if ([self canMoveTo:_selectedChessman target:target])
            {
                //移除原来位置上的棋子
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:itemArray];
                for (Chessman *info in tmp)
                {
                    if (info == _selectedChessman)
                    {
                        [itemArray removeObject:info];
                    }
                }
                Chessman *killedChessman=[self chessmanAtPosition:target];
                Position from=_selectedChessman.position;
                [_selectedChessman moveTo:target];
                _items[from.y][from.x]=nil;
                _items[target.y][target.x]=_selectedChessman;
                
                //添加新位置上的棋子
                [itemArray addObject:_items[target.y][target.x]];
                
                if (_delegate!=nil)
                {
                    [_delegate chessboard:self moveChessman:_selectedChessman from:from to:target killedChessman:killedChessman];
                }
                _selectedChessman=nil;
                if (killedChessman!=nil)
                {
                    //移除掉被吃掉的棋子
                    for (Chessman *info in tmp)
                    {
                        if (info == killedChessman)
                        {
                            [itemArray removeObject:info];
                        }
                    }
                }
                _currentOffensive=_currentOffensive==kRed?kBlack:kRed;
            }
        }

    }
  
}
//判断特殊棋子能不能移动
-(BOOL)canMoveTo:(Chessman *)chessman target:(Position )target
{
    NSMutableArray *array = [NSMutableArray arrayWithArray:itemArray];
    [array removeObject:chessman];
    
    if ([chessman.name isEqualToString:@"象"])
    {
        int stepX = (chessman.position.x + target.x) / 2;
        int stepY = (chessman.position.y + target.y) / 2;        
    
        for (Chessman *info in array)
        {
            if ((info.position.x == stepX) && (info.position.y == stepY))
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"象被别到象眼" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
        }
    }
    else if ([chessman.name isEqualToString:@"马"])
    {
        int stepX = (chessman.position.x + target.x) / 2;
        int stepY = (chessman.position.y + target.y) / 2;
                
        for (Chessman *info in array)
        {
            if (((info.position.x == chessman.position.x) && (info.position.y == stepY))||((info.position.x == stepX) && (info.position.y == chessman.position.y)))
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"马被别到马腿" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                [alert show];
                return NO;
            }
        }

    }
    else if ([chessman.name isEqualToString:@"炮"])
    {
        for (Chessman *info in array)
        {
            if (target.x == info.position.x && target.y == info.position.y)
            {
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:array];
                [tmp removeObject:info];
                
                int i=0;

                for (Chessman *ches in tmp)
                {
                    int stepX1 = ches.position.x - chessman.position.x;
                    int stepX2 = target.x - ches.position.x;
                    
                    int stepY1 = ches.position.y - chessman.position.y;
                    int stepY2 = target.y - ches.position.y;
                    if (((ches.position.x == target.x && stepY1 * stepY2 >0)||(ches.position.y == target.y && stepX1 * stepX2 >0)))
                    {
                        i++;
                    }
                }
                if (i == 1)
                {
                    return YES;
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"炮必须隔山吃子" delegate:self cancelButtonTitle:@"确认" otherButtonTitles:nil, nil];
                    [alert show];
                    return NO;
                }
            }
        }
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView == reset)
    {
        if (buttonIndex == 1)
        {
//            [itemArray removeAllObjects];
//            [self set];
            
        }
    }
}
//初始化
-(void)set
{
    for (int y=0; y<10; y++) {
        for (int x=0; x<9; x++) {
            if (_items[y][x]!=nil) {
                _items[y][x]=nil;
            }
        }
    }
    
    _currentOffensive=kRed;
    _selectedChessman=nil;
    
    //Black.
    _items[0][0]=[[Car alloc] initWithOffensiveType:kBlack];
    _items[0][1]=[[Horse alloc] initWithOffensiveType:kBlack];
    _items[0][2]=[[Elephant alloc] initWithOffensiveType:kBlack];
    _items[0][3]=[[Shi alloc] initWithOffensiveType:kBlack];
    _items[0][4]=[[Jiang alloc] initWithOffensiveType:kBlack];
    _items[0][5]=[[Shi alloc] initWithOffensiveType:kBlack];
    _items[0][6]=[[Elephant alloc] initWithOffensiveType:kBlack];
    _items[0][7]=[[Horse alloc] initWithOffensiveType:kBlack];
    _items[0][8]=[[Car alloc] initWithOffensiveType:kBlack];
    
    _items[3][0]=[[Bing alloc] initWithOffensiveType:kBlack];
    _items[3][2]=[[Bing alloc] initWithOffensiveType:kBlack];
    _items[3][4]=[[Bing alloc] initWithOffensiveType:kBlack];
    _items[3][6]=[[Bing alloc] initWithOffensiveType:kBlack];
    _items[3][8]=[[Bing alloc] initWithOffensiveType:kBlack];
    
    _items[2][1]=[[Pao alloc] initWithOffensiveType:kBlack];
    _items[2][7]=[[Pao alloc] initWithOffensiveType:kBlack];
    //Red
    _items[9][0]=[[Car alloc] initWithOffensiveType:kRed];
    _items[9][1]=[[Horse alloc] initWithOffensiveType:kRed];
    _items[9][2]=[[Elephant alloc] initWithOffensiveType:kRed];
    _items[9][3]=[[Shi alloc] initWithOffensiveType:kRed];
    _items[9][4]=[[Jiang alloc] initWithOffensiveType:kRed];
    _items[9][5]=[[Shi alloc] initWithOffensiveType:kRed];
    _items[9][6]=[[Elephant alloc] initWithOffensiveType:kRed];
    _items[9][7]=[[Horse alloc] initWithOffensiveType:kRed];
    _items[9][8]=[[Car alloc] initWithOffensiveType:kRed];
    
    _items[6][0]=[[Bing alloc] initWithOffensiveType:kRed];
    _items[6][2]=[[Bing alloc] initWithOffensiveType:kRed];
    _items[6][4]=[[Bing alloc] initWithOffensiveType:kRed];
    _items[6][6]=[[Bing alloc] initWithOffensiveType:kRed];
    _items[6][8]=[[Bing alloc] initWithOffensiveType:kRed];
    
    _items[7][1]=[[Pao alloc] initWithOffensiveType:kRed];
    _items[7][7]=[[Pao alloc] initWithOffensiveType:kRed];
    
    itemArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int y=0; y<10; y++)
    {
        for (int x=0; x<9; x++)
        {
            if (_items[y][x]!=nil)
            {
                _items[y][x].position=PositionMake(x, y);
                _items[y][x].chessboard=self;
                [itemArray addObject:_items[y][x]];
            }
        }
    }

}

@end
