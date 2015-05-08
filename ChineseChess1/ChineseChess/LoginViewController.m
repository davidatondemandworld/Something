//
//  LoginViewController.m
//  ChineseChess
//
//  Created by Bourbon on 13-10-25.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "LoginViewController.h"
#import "ViewController.h"
#import "FriendListViewController.h"
#import <MultipeerConnectivity/MultipeerConnectivity.h>

#define SERVICE_TYPE @"etayu"

@interface LoginViewController()<UIAlertViewDelegate,MCSessionDelegate,MCBrowserViewControllerDelegate,ViewDelegate>
{
    MCPeerID *_peerID;
    MCSession *mcSession;
    MCAdvertiserAssistant *adVertiserAssistant;
    MCBrowserViewController *browser;
    NSMutableArray *peerIDArray;
    BOOL searchClient;
}
@end
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
    
    _peerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    mcSession = [[MCSession alloc] initWithPeer:_peerID];
    [mcSession setDelegate:self];
    peerIDArray = [[NSMutableArray alloc] init];
    searchClient = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)clickPlayWithFriend:(id)sender
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"选择本设备的角色" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"搜索端",@"被搜索端", nil];
    alert.tag = 9001;
    [alert show];
}
-(void)clickPlayWithInternet:(id)sender
{
    FriendListViewController *friendList = [[FriendListViewController alloc] initWithStyle:UITableViewStylePlain];
    
    [self.navigationController pushViewController:friendList animated:YES];
}
-(void)clickPlayWithComputer:(id)sender
{

}
#pragma mark UIAlertView Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (alertView.tag == 9001)
    {
        NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
        if ([title isEqualToString:@"被搜索端"])
        {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请确认本机的蓝牙或wifi已经打开,点击确认开始启动服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert1 setTag:9003];
            [alert1 show];
        }
        else if ([title isEqualToString:@"搜索端"])
        {
            UIAlertView *alert1 = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"请确认本机的蓝牙或wifi已经打开,点击确认开始搜索主机" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
            [alert1 setTag:9002];
            [alert1 show];
        }
    }
    else if (alertView.tag == 9002)
    {
        //查找主机
        if (buttonIndex == 1)
        {
            searchClient = NO;
            if (browser == nil)
            {
                browser = [[MCBrowserViewController alloc] initWithServiceType:SERVICE_TYPE session:mcSession];
                [browser setDelegate:self];
            }
            [self presentViewController:browser animated:YES completion:nil];
        }
    }
    else if (alertView.tag == 9003)
    {
        ///启动服务
        if (buttonIndex == 1)
        {
            if (adVertiserAssistant == nil)
            {
                adVertiserAssistant = [[MCAdvertiserAssistant alloc] initWithServiceType:SERVICE_TYPE discoveryInfo:nil session:mcSession];
                [adVertiserAssistant start];
            }
        }
    }
}
#pragma mark MCSessionDelegate
-(void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateNotConnected:
            NSLog(@"没链接上");
            [mcSession disconnect];
            if (searchClient)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"disconnect" object:nil];
            }
            break;
        case MCSessionStateConnecting:
            NSLog(@"正在链接");
            break;
        case MCSessionStateConnected:
        {
            
            NSLog(@"已经链接上");
            [peerIDArray addObject:peerID];
            if (searchClient)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ViewController *view = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
                    [view setDelegate:self];
                    [self presentViewController:view animated:YES completion:nil];
                });

            }
            else
            {
                [browser dismissViewControllerAnimated:YES completion:^{
                    ViewController *view = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
                    [view setDelegate:self];
                    [self presentViewController:view animated:YES completion:nil];
                }];
            }
 
            break;
        }
        default:
            break;
    }
}
-(void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    NSString *name = peerID.displayName;
    NSLog(@"接受到了数据来自:%@",name);
    dispatch_async(dispatch_get_main_queue(), ^{

        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableLeaves) error:nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"move" object:dict];
        
    });

}
-(void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"接受到了流:%@",streamName);
}
-(void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"开始接受来源:%@",resourceName);
}
-(void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    NSLog(@"可能是接受完数据吧%@",resourceName);
}
#pragma mark MCBrowserViewControllerDelegate
-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
    NSLog(@"结束");
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}
-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController
{
    NSLog(@"取消了");
    [browserViewController dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark ViewDelegate
-(void)clickBackButton
{
    [mcSession disconnect];
}
-(void)moveChessManWithDic:(NSMutableDictionary *)dict
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:(NSJSONWritingPrettyPrinted) error:nil];
    BOOL success = [mcSession sendData:data toPeers:peerIDArray withMode:(MCSessionSendDataReliable) error:nil];
    if (success)
    {
        NSLog(@"发送成功:%@",dict);
    }
    else
    {
        NSLog(@"发送失败:%@",dict);
    }
}
@end
