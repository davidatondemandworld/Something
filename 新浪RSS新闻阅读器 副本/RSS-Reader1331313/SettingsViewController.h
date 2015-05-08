//
//  SettingsViewController.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-22.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "ConnectionDelegate.h"
@interface SettingsViewController : UITableViewController<ConnectionDelegate,UIAlertViewDelegate>
{
    Connection *_connection;
}
@property (nonatomic,strong) UIColor *backColor;
@end
