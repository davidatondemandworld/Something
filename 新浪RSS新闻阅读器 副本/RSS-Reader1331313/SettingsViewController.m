//
//  SettingsViewController.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-22.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "ColorSelectViewController.h"
#import "Connection.h"
@implementation SettingsViewController
@synthesize backColor;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.tintColor = app._naviColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"Setting", @"设置");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
    {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    if (indexPath.section ==0) {
        cell.textLabel.text = NSLocalizedString(@"Internationalization", @"国际化");
    }
    else if (indexPath.section == 1)
    {
        cell.textLabel.text = NSLocalizedString(@"change color", @"更改颜色");
    }
    else if (indexPath.section == 2)
    {
        cell.textLabel.text = NSLocalizedString(@"quit", @"退出");
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Change the language", @"Change the language") message:nil delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"取消") otherButtonTitles:@"简体中文",@"English", nil];
        [alert show];
    }
    else if (indexPath.section == 1)
    {
        ColorSelectViewController *color = [[ColorSelectViewController alloc] initWithStyle:(UITableViewStyleGrouped)];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:color];
        [self presentViewController:navi
                           animated:YES completion:nil];
        
    }
    else if(indexPath.section == 2)
    {
#warning 退出登陆
        _connection = [[Connection alloc] initWithHostAddress:@"127.0.0.1" andPort:1024];
        BOOL succeed = [_connection connect];
        if (!succeed) {
            [_connection close];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络错误" message:@"无法连接服务器" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
            [alert show];
            NSLog(@"connect to %@:%i failed!",_connection.peerhost,_connection.peerport);
        }
        _connection.delegate = self;
        
        NSDictionary *packet = [[NSDictionary alloc] initWithObjectsAndKeys:@"exit",@"send",@"",@"msg",@"",@"msg2", nil];
        
        [_connection sendNetworkPacket:packet];
        
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%i",buttonIndex);
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

}
@end
