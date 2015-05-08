//
//  ChessmanView.h
//  ChineseChess
//
//  Created by 深圳鲲鹏 on 13-5-21.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChessmanView : UIView{
    UIImage *_backgroundImage;    
    NSString *_text;
    UIFont *_textFont;
    UIColor *_textColor;
    CGRect _textFrame;
    BOOL _highlighted;    
}

@property (nonatomic,strong) UIImage *backgroundImage;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,strong) UIFont *textFont;;
@property (nonatomic,strong) UIColor *textColor;
@property (nonatomic,assign,getter=isHighlighted) BOOL highlighted;

- (void) setHighlighted:(BOOL)highlighted animated:(BOOL)animated;
@end
