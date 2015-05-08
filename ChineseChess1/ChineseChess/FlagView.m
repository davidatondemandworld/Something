//
//  FlagView.m
//  ChineseChess
//
//  Created by Andy Tung on 13-5-28.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "FlagView.h"

@implementation FlagView

@synthesize offensiveType=_offensiveType;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _image=[UIImage imageNamed:@"bg-flag.png"];        
    }
    return self;
}

- (OffensiveType)offensiveType{
    return _offensiveType;
}

- (void)setOffensiveType:(OffensiveType)offensiveType{
    _offensiveType=offensiveType;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGFloat x = _offensiveType==kRed?0.0f:-30.0f;
    CGPoint p=CGPointMake(x, 0.0f);
    [_image drawAtPoint:p];
}

@end
