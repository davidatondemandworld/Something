//
//  FlagView.h
//  ChineseChess
//
//  Created by Andy Tung on 13-5-28.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"

@interface FlagView : UIView{
    OffensiveType _offensiveType;
    UIImage *_image;    
}

@property (assign) OffensiveType offensiveType;

@end
