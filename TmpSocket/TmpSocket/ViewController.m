//
//  ViewController.m
//  TmpSocket
//
//  Created by BourbonZ on 14/12/11.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)click:(id)sender
{
    SocketHelper *socket = [SocketHelper sharedSocket];
    socket.delegate = self;
    [socket sendMessage];
}
- (IBAction)disConnect:(id)sender
{
    SocketHelper *socket = [SocketHelper sharedSocket];
    [socket disConnect];
}
- (IBAction)reConnect:(id)sender
{
    SocketHelper *socket = [SocketHelper sharedSocket];
    [socket connectToHost];
}
- (IBAction)isConnect:(id)sender
{
    SocketHelper *socet = [SocketHelper sharedSocket];
    [socet connectState];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)receiveMessage:(NSData *)data
{
    
}
@end
