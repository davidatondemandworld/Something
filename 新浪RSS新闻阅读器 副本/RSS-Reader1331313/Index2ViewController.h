//
//  Index2ViewController.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-22.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GDataXMLNode.h"

@interface Index2ViewController : UITableViewController
{
    NSArray *totleChannels;
}
@property (nonatomic,strong) NSArray *_channels;
@end
