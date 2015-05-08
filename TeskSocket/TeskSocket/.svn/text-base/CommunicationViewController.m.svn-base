//
//  CommunicationViewController.m
//  TeskSocket
//
//  Created by apple on 13-5-23.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import "CommunicationViewController.h"
#import "SocketAppDelegate.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
@interface CommunicationViewController ()

@end

@implementation CommunicationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    }
    return self;
}
- (NSString *)getIPAddress
{
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0)
    {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL)
        {
            if(temp_addr->ifa_addr->sa_family == AF_INET)
            {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"])
                {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [SocketAppDelegate sharedAppDelegate].isServer = kClient;
    NSString *s1 = [NSString stringWithFormat:@"系统版本：%@",[[UIDevice currentDevice] systemVersion]];
    NSString *s2 = [NSString stringWithFormat:@"设备型号：%@",[[UIDevice currentDevice] model]];
    NSString *s3 = [NSString stringWithFormat:@"设备名称：%@",[[UIDevice currentDevice] name]];
    NSString *s4 = [NSString stringWithFormat:@"IP:%@",[self getIPAddress]];
    NSMutableArray * array = [[NSMutableArray alloc] initWithObjects:s1,s2,s3,s4,nil];
    for (int i = 0; i < 4; i ++)
    {
        UILabel *l = [[UILabel alloc] initWithFrame:CGRectMake(50,100 + i * 60, 230, 50)];
        l.text = [array objectAtIndex:i];
        [self.view addSubview:l];
        [l release];
    }
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backWasPressed:(id)sender
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    NSLog(@"type = %d",[SocketAppDelegate sharedAppDelegate].isServer);
}

- (IBAction)connect:(id)sender
{
    
}
- (void)dealloc {
    [_ipField release];
    [_portField release];
    [super dealloc];
}
@end
