//
//  ChessmanView.m
//  ChineseChess
//
//  Created by 深圳鲲鹏 on 13-5-21.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "ChessmanView.h"

@implementation ChessmanView

@synthesize backgroundImage=_backgroundImage;
@synthesize text=_text;
@synthesize textColor=_textColor;
@synthesize textFont=_textFont;
@synthesize highlighted=_highlighted;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        _textFrame=CGRectInset(self.bounds, self.frame.size.width/4.0f, self.frame.size.height/4.0f);
        _textFont = [UIFont boldSystemFontOfSize:_textFrame.size.width];        
        _backgroundImage = [UIImage imageNamed:@"bg-chessman.png"];
        
        _text=@"棋";        
        _textColor = [UIColor redColor];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted{
    if (_highlighted != highlighted) {
        float scale=highlighted?-5.f:5.0f;
        self.frame=CGRectInset(self.frame, scale, scale);
        _highlighted=highlighted;
        _textFrame=CGRectInset(self.bounds, self.frame.size.width/4.0f, self.frame.size.height/4.0f);
        _textFont = [UIFont boldSystemFontOfSize:_textFrame.size.width];
    } 
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5f];
    }    
    [self setHighlighted:highlighted];
    if (animated) {
        [UIView commitAnimations];
    }
}

- (void)drawRect:(CGRect)rect
{    
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    CGContextDrawImage(ctx, self.bounds, [_backgroundImage CGImage]);
    
    CGFloat red,green,blue,alpha; 
    [_textColor getRed:&red green:&green blue:&blue alpha:&alpha];
	CGContextSetRGBFillColor(ctx,red ,green,blue,alpha);    
    [_text drawInRect:_textFrame withFont:_textFont];  
}


@end
