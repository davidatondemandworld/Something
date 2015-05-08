//
//  ArticleListController.h
//  RSSReader
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Channel;

@interface ArticleListController : UITableViewController{
    NSArray *_articles;
    Channel *_channel;        
}

@property (nonatomic,retain) NSArray *articles;
@property (nonatomic,retain) Channel *channel;

@end
