//
//  MsgViewController.m
//  TCPClient-Mac
//
//  Created by apple on 12-4-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MsgViewController.h"

@interface MsgViewController() 

- (void)displayMessage:(NSString *)message;

@end

@implementation MsgViewController

@synthesize msgTextView,msgTextField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        _connection = [[Connection alloc] initWithHostAddress:@"192.168.1.172" andPort:1024];
        BOOL succeed = [_connection connect];
        if ( !succeed ) {
            [_connection close];
            NSLog(@"connect to %@:%ld failed!",_connection.peerhost,_connection.peerport);
        } 
        _connection.delegate = self;
    }
    
    return self;
}


- (void)dealloc
{
    [super dealloc];
}

- (void)sendMsg:(NSButton *) sender{
    NSDictionary *packet=[NSDictionary dictionaryWithObject:[self.msgTextField stringValue] forKey:@"msg"];
    [_connection sendNetworkPacket:packet];
    
    NSString * msg = [NSString stringWithFormat:@"from %@:%i, %@", _connection.host, _connection.port, [self.msgTextField stringValue]]; 
    
    [self displayMessage:msg];
}

#pragma mark - ConnectionDelegate

- (void)connectionTerminated:(Connection *)connection{
    NSLog(@"connectionTerminated");
}

- (void)connectionAttemptFailed:(Connection *)connection{
    NSLog(@"connectionAttemptFailed");
}

- (void)receivedNetworkPacket:(NSDictionary *)message viaConnection:(Connection *)connection{   
    NSString * msg = [NSString stringWithFormat:@"from %@:%i, %@", connection.peerhost, connection.peerport, [message objectForKey:@"msg"]]; 
    
    [self displayMessage:msg];
}

// We are being asked to display a chat message
- (void)displayMessage:(NSString *)message{  
    NSString * currentString = [NSString stringWithFormat:@"%@\n%@", [self.msgTextView string], message];
    [self.msgTextView setString:currentString];
    
    NSRange range = [currentString rangeOfString:message options:NSBackwardsSearch];
    [self.msgTextView scrollRangeToVisible:range];
}

@end
