//
//  FriendListViewController.h
//  ChineseChess
//
//  Created by Bourbon on 13-10-25.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "ConnectionDelegate.h"
@interface FriendListViewController : UITableViewController<ConnectionDelegate,UIAlertViewDelegate>
{
    NSMutableArray *friendList;
    Connection *_connection;
}
@end
