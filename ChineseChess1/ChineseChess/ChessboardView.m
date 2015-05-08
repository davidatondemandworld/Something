//
//  BoardView.m
//  ChineseChess
//
//  Created by 深圳鲲鹏 on 13-5-21.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "ChessboardView.h"
#import "ChessmanView.h"
#import "FlagView.h"

@interface ChessboardView()
- (void)getViewPoint:(CGPoint *)viewPoint atX:(int)x andY:(int) y;
- (void)drawFlagInContext:(CGContextRef ) ctx AtX:(int) x andY:(int) y;
- (void) onTap:(id) sender;
@end

@implementation ChessboardView

@synthesize delegate=_delegate;
@synthesize gridSize=_gridSize;
@synthesize lineColor=_lineColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code         
        _gridSize.width=frame.size.width/9.0f;
        _gridSize.height=frame.size.height/10.0f;
        _offset.width=_gridSize.width/2.0f;
        _offset.height=_gridSize.height/2.0f;
        _flagSize.width=_gridSize.width/5.0f;
        _flagSize.height=_gridSize.height/5.0f;
        _flagPadding=3.0f;
        _lineWidth=2.0f;
        _lineColor=[UIColor redColor];
        
        UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        gesture.numberOfTapsRequired=1;
        [self addGestureRecognizer:gesture];
        
        self.clipsToBounds=YES;
    }
    return self;
}


- (void)loadData{  
    if (_delegate != nil) {
        Position pos;
        ChessmanView *vw=nil;
        for (int y=0; y<10; y++) {
            for (int x=0; x<9; x++) {
                if (_items[y][x]!=nil) {
                    [_items[y][x] removeFromSuperview];
                }
                
                pos.x=x,pos.y=y;
                vw=[_delegate chessboardView:self chessmanViewAtPosition:pos];
                _items[y][x]=vw;
                if (vw!=nil) {                    
                    [self addSubview:vw];
                }
            }
        }
        _flagView=[[FlagView alloc] initWithFrame:CGRectMake(-28.0f, -28.0f, 28.0f, 28.0f)];
        _flagView.backgroundColor=[UIColor clearColor];
        _flagView.offensiveType=kBlack;
        [self addSubview:_flagView];
    }
}

- (void) selectChessmanViewAtPosition:(Position) pos animated:(BOOL)animated{
    ChessmanView *vw=_items[pos.y][pos.x];    
    if (vw!=nil) {
        [self bringSubviewToFront:vw];
        [vw setHighlighted:YES animated:animated];
    }
}
- (void) deselectChessmanViewAtPosition:(Position) pos animated:(BOOL)animated{
    ChessmanView *vw=_items[pos.y][pos.x];
    if (vw!=nil) {
        [vw setHighlighted:NO animated:animated];
    }
}
- (void) moveChessmanViewAtPosition:(Position) from to:(Position) target animated:(BOOL)animated
{
    ChessmanView *vw=_items[from.y][from.x];
    if (vw!=nil)
    {
        _flagView.center=vw.center;
        _flagView.offensiveType=_flagView.offensiveType==kRed?kBlack:kRed;
        if (animated)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.5f];
        }
        
        ChessmanView *vw2=_items[target.y][target.x];
        if (vw2!=nil)
        {
            [vw2 removeFromSuperview];
        }     
        
        CGPoint p = CGPointMake(target.x*_gridSize.width+_offset.width, target.y*_gridSize.height+_offset.height);        
        vw.center=p;
        _items[target.y][target.x]=vw;
        _items[from.y][from.x]=nil;
        
        if (animated)
        {
            [UIView commitAnimations];          
        }
        
        [vw setHighlighted:NO animated:YES];
    }
}

- (void)onTap:(id)sender
{
    if (_delegate != nil)
    {
        UIGestureRecognizer *gesture=(UIGestureRecognizer *)sender;
        CGPoint point = [gesture locationInView:self];
        Position pos;
        pos.x=(int)(point.x/_gridSize.width);
        pos.y=(int)(point.y/_gridSize.height);
        [_delegate chessboardView:self touchAtPosition:pos];
    }
}

#pragma mark - about draw

- (void)getViewPoint:(CGPoint *)viewPoint atX:(int)x andY:(int) y{
    viewPoint->x=_gridSize.width*x+_offset.width;
    viewPoint->y=_gridSize.height*y+_offset.height;
}

- (void)drawFlagInContext:(CGContextRef) ctx AtX:(int)x andY:(int)y{
    CGPoint center,p1;
    [self getViewPoint:&center atX:x andY:y];
    
    
    for (int x2=-1; x2<=1; x2+=2) {
        if ((x==0&&x2==-1)||(x==8&&x2==1)) {
            continue;
        }
        for (int y2=-1; y2<=1; y2+=2) {
            p1.x=center.x+x2*_flagPadding;
            p1.y=center.y+y2*_flagPadding;            
            CGContextMoveToPoint(ctx, p1.x, p1.y);
            CGContextAddLineToPoint(ctx, p1.x, p1.y+y2*_flagSize.height);
            CGContextMoveToPoint(ctx, p1.x, p1.y);
            CGContextAddLineToPoint(ctx, p1.x+x2*_flagSize.height, p1.y);
            CGContextStrokePath(ctx);
        }
    } 
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGFloat red,green,blue,alpha;
    CGPoint point,point2;
    CGFloat len;
    int i;
    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    [_lineColor getRed:&red green:&green blue:&blue alpha:&alpha];
	CGContextSetRGBStrokeColor(ctx,red ,green,blue,alpha);	
	CGContextSetLineWidth(ctx, _lineWidth);
    //绘制横线
    [self getViewPoint:&point atX:0 andY:0];    
    len=_gridSize.width*8.0f;
    for (i=0; i<10; i++) {
        CGContextMoveToPoint(ctx, point.x, point.y);
        CGContextAddLineToPoint(ctx, point.x+len, point.y);
        CGContextStrokePath(ctx);
        point.y+=_gridSize.height;
    }
    
    //绘制左右边线
    [self getViewPoint:&point atX:0 andY:0];    
    len=_gridSize.height*9.0f;
    for (i=0; i<2; i++) {
        CGContextMoveToPoint(ctx, point.x, point.y);
        CGContextAddLineToPoint(ctx, point.x, point.y+len);
        CGContextStrokePath(ctx);
        point.x+=_gridSize.width*8.0f;
    }
    //绘制竖线
    len=_gridSize.height*4.0f;
    for (i=0; i<2; i++) {
        [self getViewPoint:&point atX:1 andY:i*5];
        for (int j=1; j<8; j++) {
            CGContextMoveToPoint(ctx, point.x, point.y);
            CGContextAddLineToPoint(ctx, point.x, point.y+len);
            CGContextStrokePath(ctx);
            point.x+=_gridSize.width;
        }
    }    
    //绘制斜线
    int points[8][2]={{3,0},{5,2},{3,2},{5,0},{3,7},{5,9},{3,9},{5,7}};
    for (i=0; i<8; i+=2) {
        [self getViewPoint:&point atX:points[i][0] andY:points[i][1]];
        [self getViewPoint:&point2 atX:points[i+1][0] andY:points[i+1][1]];
        CGContextMoveToPoint(ctx, point.x, point.y);
        CGContextAddLineToPoint(ctx, point2.x, point2.y);
        CGContextStrokePath(ctx);
    }
    //绘制棋标
    CGPoint flags[14]={{1,2},{7,2},{0,3},{2,3},{4,3},{6,3},{8,3},{1,7},{7,7},{0,6},{2,6},{4,6},{6,6},{8,6}};
    for (i=0; i<14; i++) {
        [self drawFlagInContext:ctx AtX:flags[i].x andY:flags[i].y];
    }
}

@end
