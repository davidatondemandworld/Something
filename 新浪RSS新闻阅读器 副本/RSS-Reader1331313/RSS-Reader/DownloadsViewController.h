//
//  DownloadsViewController.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-22.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadsViewController : UITableViewController
{
    NSMutableArray *_channelArray;
    UIActivityIndicatorView *activity;
}
@end
