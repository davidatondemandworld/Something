//
//  ListenerViewController.m
//  TCPListner
//
//  Created by apple on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "ListenerViewController.h"
#import "TCPListner.h"
#import "Connection.h"
#import "LoginManager.h"
#import "Login.h"
@interface ListenerViewController() 

- (void)displayMessage:(NSString *)message;

@end

@implementation ListenerViewController

@synthesize connectionsTableView,msgTextView,msgTextField;
@synthesize listner;

#pragma mark Lifecycle


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {        
        connections = [[NSMutableArray alloc] init];  
        isListning = NO;
        
        self.listner=[[TCPListner alloc] initWithPort:1024];         
        self.listner.delegate = self;
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark Listning controls

- (void)startOrStop:(NSButton *)sender{
    if (!isListning) {        
        [self.listner start];
        
        isListning=YES;
        [sender setTitle:@"Stop"];        
    }  
    else{
        [self.listner stop];
        
        isListning=NO;
        [sender setTitle:@"Start"];
        
        [connections removeAllObjects];
        [self.connectionsTableView reloadData];
    }
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
    return [connections count];
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
    
    NSString *colName=[tableColumn identifier];
    Connection *cn=[connections objectAtIndex:row];
    
    if ([colName isEqualToString:@"HOST"]) {
        return cn.peerhost;
    }
    else if([colName isEqualToString:@"PORT"]){
        return [NSNumber numberWithInteger:cn.peerport];
    }
    
    return NULL;
}

#pragma mark - TcpListnerDelegate

- (void)handleNewConnection:(Connection *)connection{
    connection.delegate=self; 
    [connections addObject:connection];
    [self.connectionsTableView reloadData];
    NSString *msg=[NSString stringWithFormat:@"accept a new connection from %@:%li",connection.peerhost,connection.peerport];
                   
    [self displayMessage:msg];    
}

- (void)listnerFailed:(TCPListner *)listner reason:(NSString *)reason{
    
}

#pragma mark - ConnectionDelegate

- (void)connectionTerminated:(Connection *)connection{
    NSLog(@"connectionTerminated");
    [connections removeObject:connection];
    [self.connectionsTableView reloadData];
}

- (void)connectionAttemptFailed:(Connection *)connection{
    NSLog(@"connectionAttemptFailed");
}

- (void)receivedNetworkPacket:(NSDictionary *)message viaConnection:(Connection *)connection{
    
    NSString * send = [message objectForKey:@"send"];
    NSString * msg = [message objectForKey:@"msg"];
    NSString * msg2 = [message objectForKey:@"msg2"];
    
    Login *login = [[Login alloc] init];
    login._name = msg;
    login._psw = msg2;
    
    NSString *msg3 = [[NSString alloc] init];

    if ([send isEqualToString:@"login"])
    {
        Login *tmp = [[LoginManager defaultManager] selectLoginByName:login._name];
        
        if (tmp == nil) {
            msg3 = @"用户名没有注册";
        }
        else
        {
            if ([tmp._psw isEqualToString:login._psw]) {
                msg3 = @"登陆成功";
            } else {
                msg3 = @"用户名或密码错误";
            }
        }
    }
    else if ([send isEqualToString:@"register"])
    {
        Login *tmp2 = [[LoginManager defaultManager] selectLoginByName:login._name];
        if (tmp2 == nil) {
            [[LoginManager defaultManager] addLogin:login error:nil];
            msg3 = @"注册成功";
        }
        else
        {
            msg3 = @"已有该用户名，请换个名字";
        }      
    }
    else if ([send isEqualToString:@"exit"])
    {
#warning 重复登陆
    }
    
    NSDictionary *packet3=[NSDictionary dictionaryWithObject:msg3 forKey:@"msg3"];
    NSInteger row = 0;
    Connection *connection3=[connections objectAtIndex:row];
    [connection3 sendNetworkPacket:packet3];

    msg = [NSString stringWithFormat:@"用户名:%@",msg];
    msg2 = [NSString stringWithFormat:@"密码:%@",msg2];
    
    [self displayMessage:msg];
    [self displayMessage:msg2];
}    
     
// We are being asked to display a chat message
- (void)displayMessage:(NSString *)message
{    
    NSString * currentString = [NSString stringWithFormat:@"%@\n%@", [self.msgTextView string], message];
    [self.msgTextView setString:currentString];
    
    NSRange range = [currentString rangeOfString:message options:NSBackwardsSearch];
    [self.msgTextView scrollRangeToVisible:range];
}

@end
