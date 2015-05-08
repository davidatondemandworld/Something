//
//  DetailViewController.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-23.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Channel.h"
#import "DetailChannel.h"

@interface DetailViewController : UITableViewController<NSXMLParserDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIBarButtonItem *editButton;
    
    NSMutableArray *_totalDetailChannels;
    NSMutableString *_currentElement;
    DetailChannel *_detailChannel;
    
    NSArray *_total;
    
    UIActivityIndicatorView *activity;
}
@property (nonatomic,strong) Channel *channel;
@end
