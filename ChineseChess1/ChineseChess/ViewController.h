//
//  ViewController.h
//  ChineseChess
//
//  Created by 深圳鲲鹏 on 13-5-21.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChessboardView.h"
#import "ChessBoard.h"

@protocol ViewDelegate <NSObject>

-(void)clickBackButton;
-(void)moveChessManWithDic:(NSMutableDictionary *)dict;

@end

@interface ViewController : UIViewController<ChessboardViewDelegate,ChessboardDelegate>
{
    ChessboardView *_chessboardView;
    ChessBoard *_chessboard;
}
@property (nonatomic,assign) id <ViewDelegate>delegate;
-(IBAction)clickBack:(id)sender;
-(IBAction)clickGoBack:(id)sender;
-(IBAction)clickCancle:(id)sender;
-(IBAction)clickInfo:(id)sender;

@end
