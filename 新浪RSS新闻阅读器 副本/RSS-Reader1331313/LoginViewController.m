//
//  LoginViewController.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-29.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "LoginViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import "RSSDatabase.h"
#import "DownloadsViewController.h"
#import "RSSViewController.h"
#import "FavouriteViewController.h"
#import "SettingsViewController.h"
#import "AppDelegate.h"


@implementation LoginViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _label.text = NSLocalizedString(@"click", @"点击以登录");
}
-(void)clickBackground:(id)sender
{
    [self.view endEditing:YES];
    [self login];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationMaskPortrait);
}

#pragma mark - ConnectionDelegate
-(void)connectionTerminated:(Connection *)connection
{
    NSLog(@"connectionTerminated");
}
-(void)connectionAttemptFailed:(Connection *)connection
{   
    NSLog(@"connectionAttemptFailed");
}
-(void)receivedNetworkPacket:(NSDictionary *)message viaConnection:(Connection *)connection
{
    NSString *msg = [message objectForKey:@"msg3"];
    
    if ([msg isEqualToString:@"登陆成功"]) {
        [self login];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:msg delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [alert show];
    }
}
-(void)login
{
    [RSSDatabase createDatabaseIfNotExists];
    //创建tabBar
    
    RSSViewController *rss = [[RSSViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:rss];
    
    navi.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:(UITabBarSystemItemContacts) tag:101];
    
    DownloadsViewController *down = [[DownloadsViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navi2 = [[UINavigationController alloc] initWithRootViewController:down];
    navi2.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemDownloads tag:102];
    
    FavouriteViewController *favour = [[FavouriteViewController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *navi3 =[[UINavigationController alloc] initWithRootViewController:favour];
    navi3.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:103];
    
    SettingsViewController *settings = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navi4 = [[UINavigationController alloc] initWithRootViewController:settings];
    
    navi4.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:(UITabBarSystemItemMore) tag:104];
    
    
    NSArray *tabBarArray = [NSArray arrayWithObjects:navi,navi2,navi3,navi4, nil];
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = tabBarArray;
    
    [self presentViewController:tabBarController animated:YES completion:nil];
}
@end
