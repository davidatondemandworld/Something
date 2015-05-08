//
//  ArticleDetailController.h
//  RSSReader
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Article;

@interface ArticleDetailController : UIViewController<UIWebViewDelegate>{
    UIWebView *_webView;
    Article *_article;
}

@property (nonatomic,retain) Article *article;

@end
