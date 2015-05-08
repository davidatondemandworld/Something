//
//  bleTransmitMoudelSecondViewController.h
//  bleTransmitMoudel
//
//  Created by David on 12-8-6.
//  Copyright (c) 2012年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bleShared.h"
#import "bleTransmitMoudelFirstViewController.h"
#import <MessageUI/MessageUI.h>

@interface bleTransmitMoudelSecondViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,bleTransmitMoudelAppDelegate,UITabBarControllerDelegate,MFMailComposeViewControllerDelegate>{
    bleShared *shared;
    UITabBarController *tabBar;
}

@property (retain, nonatomic) IBOutlet UITableView *sensorsTable;

- (IBAction)linkWebButton:(id)sender;

@end
