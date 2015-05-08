//
//  IndexViewController.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-22.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"
@interface IndexViewController : UITableViewController<NSXMLParserDelegate>
{
    UIActivityIndicatorView *activity;
    NSMutableArray *totalChannels;
}
@property (nonatomic,copy) NSString *title;
@property (nonatomic,strong) NSMutableArray *array;
@end
