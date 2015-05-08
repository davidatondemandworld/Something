//
//  WCFindFriendsViewController.h
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCFindFriendsViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_friendsArray;
    IBOutlet UITableView *_friendTable;
    
    IBOutlet UIWebView *web;
    IBOutlet UIView *findView;
    int _pageIndex;
    int _pageSize;
}
- (IBAction)searchUser:(id)sender;
- (IBAction)closeFind:(id)sender;
- (IBAction)webBack:(id)sender;

@end
