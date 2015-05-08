//
//  EasyActivityIndicatorView.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-23.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "EasyActivityIndicatorView.h"
#import "AppDelegate.h"

@implementation EasyActivityIndicatorView

- (void)startAnimating{
    UIWindow *window=((AppDelegate *)[[UIApplication sharedApplication] delegate]).window;
    if (_alphaView==nil) {
        _alphaView=[[UIView alloc] initWithFrame:window.frame];
        _alphaView.backgroundColor=[UIColor orangeColor];
        _alphaView.alpha=0.5f;
        _alphaView.userInteractionEnabled=NO;
        self.center=_alphaView.center;
    }  
    
    window.userInteractionEnabled=NO;
    [window addSubview:_alphaView];
    [window addSubview:self];
    
    [super startAnimating];
}

- (void)stopAnimating{ 
    [super stopAnimating];
    [self removeFromSuperview];
    [_alphaView removeFromSuperview];  
    
    UIWindow *window=((AppDelegate *)[[UIApplication sharedApplication] delegate]).window;    
    window.userInteractionEnabled=YES;
}

@end
