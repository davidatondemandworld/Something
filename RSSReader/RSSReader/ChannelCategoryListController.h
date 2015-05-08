//
//  ChannelCategoryListController.h
//  RSSReader
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChannelSource;

@interface ChannelCategoryListController : UITableViewController{
    ChannelSource *_channelSource;
    NSDictionary *_channelsDict;
    NSArray *_categories;
    
    UIActivityIndicatorView *_activityIndicatorView;
}

@property (nonatomic,retain) ChannelSource *channelSource;


@end
