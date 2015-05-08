//
//  ViewController.m
//  ChineseChess
//
//  Created by 深圳鲲鹏 on 13-5-21.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "ViewController.h"
#import "ChessmanView.h"
#import "Chessman.h"

@interface ViewController ()<UIAlertViewDelegate>

@end

@implementation ViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    _chessboard=[[ChessBoard alloc] init];
    _chessboard.delegate=self;
    [_chessboard reset];
    
    _chessboardView=[[ChessboardView alloc] initWithFrame:CGRectMake(7.0f, 25.0f, 306.0f, 340.0f)];
    _chessboardView.backgroundColor=[UIColor clearColor];
    _chessboardView.delegate=self;
    [_chessboardView loadData];
    [self.view addSubview:_chessboardView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disconnectView:) name:@"disconnect" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveMove:) name:@"move" object:nil];
}
-(void)disconnectView:(NSNotification *)notify
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)receiveMove:(NSNotification *)notify
{
    NSDictionary *dict = [notify object];
    
    NSDictionary *fromDict = [dict objectForKey:@"from"];
    NSDictionary *toDict   = [dict objectForKey:@"to"];
    Position from = PositionMake([[fromDict objectForKey:@"fromX"] intValue], [[fromDict objectForKey:@"fromY"] intValue]);
    Position target = PositionMake([[toDict objectForKey:@"toX"] intValue], [[toDict objectForKey:@"toY"] intValue]);
    
    [_chessboardView moveChessmanViewAtPosition:from to:target animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ChessboardViewDelegate

- (ChessmanView *)chessboardView:(ChessboardView *)chessboardView chessmanViewAtPosition:(Position)pos{
    Chessman *chessman=[_chessboard chessmanAtPosition:pos];
    if (chessman!=nil) {
        CGSize s = chessboardView.gridSize;
        CGRect rect=CGRectMake(pos.x*s.width, pos.y*s.height, s.width, s.height);
        ChessmanView *vw=[[ChessmanView alloc] initWithFrame:rect];
        vw.backgroundImage=[UIImage imageNamed:@"bg-chessman.png"];
        vw.text=chessman.name;        
        vw.textColor=chessman.offensiveType==kRed?[UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:1.0f]:[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
        return vw;
    }
    return nil;
}

- (void)chessboardView:(ChessboardView *)chessboardView touchAtPosition:(Position)pos{    
    if (_chessboard.selectedChessman==nil) {
        [_chessboard setSelectedChessmanAtPosition:pos];
        return;
    }
    
    Chessman *chessman=[_chessboard chessmanAtPosition:pos];
    if (chessman !=nil && chessman.offensiveType==_chessboard.currentOffensive) {
        [_chessboard setSelectedChessmanAtPosition:pos];
        return;
    }  
    
    [_chessboard moveSelectedChessmanTo:pos];
}

#pragma mark - ChessboardDelegate

- (void)chessboard:(ChessBoard *)chessboard didSelectChessman:(Chessman *)selectedChessman deselectChessman:(Chessman *)deselectedChessman{
    if (selectedChessman!=nil) {
        [_chessboardView selectChessmanViewAtPosition:selectedChessman.position animated:YES];
    }
    if(deselectedChessman!=nil){
        [_chessboardView deselectChessmanViewAtPosition:deselectedChessman.position animated:YES];
    }
}

- (void)chessboard:(ChessBoard *)chessboard moveChessman:(Chessman *)chessman from:(Position)from to:(Position)target killedChessman:(Chessman *)killedChessman{
    [_chessboardView moveChessmanViewAtPosition:from to:target animated:YES];
    

    NSMutableDictionary *fromDict = [NSMutableDictionary dictionary];
    [fromDict setObject:[NSNumber numberWithInt:from.x] forKey:@"fromX"];
    [fromDict setObject:[NSNumber numberWithInt:from.y] forKey:@"fromY"];
    
    NSMutableDictionary *toDict = [NSMutableDictionary dictionary];
    [toDict setObject:[NSNumber numberWithInt:target.x] forKey:@"toX"];
    [toDict setObject:[NSNumber numberWithInt:target.y] forKey:@"toY"];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:fromDict forKey:@"from"];
    [dict setObject:toDict forKey:@"to"];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(moveChessManWithDic:)])
    {
        [self.delegate moveChessManWithDic:dict];
    }
}

#pragma mark - Bar Button Item
//返回
-(void)clickBack:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"是否要退出，退出后将会断开连接" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}
//悔棋
-(void)clickGoBack:(id)sender
{
    
}
//撤销
-(void)clickCancle:(id)sender
{

}
//棋谱
-(void)clickInfo:(id)sender
{
    
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickBack:)])
        {
            [self.delegate clickBackButton];
        }
        [self dismissModalViewControllerAnimated:YES];
    }
}
@end
