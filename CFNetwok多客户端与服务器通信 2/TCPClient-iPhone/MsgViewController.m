//
//  MsgViewController.m
//  TCPClient-iPhone
//
//  Created by apple on 12-4-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MsgViewController.h"

@interface MsgViewController()
- (void)displayMessage:(NSString *)message;
@end

@implementation MsgViewController

@synthesize msgTextView,txtMsg;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)dealloc
{
    [_connection close];
    [_connection release];    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    // Custom initialization
    _connection = [[Connection alloc] initWithHostAddress:@"127.0.0.1" andPort:1024];
    BOOL succeed = [_connection connect];
    if ( !succeed ) {
        [_connection close];
        NSLog(@"connect to %@:%i failed!",_connection.peerhost,_connection.peerport);
    } 
    _connection.delegate = self;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)sendMsg{
    NSDictionary *packet=[NSDictionary dictionaryWithObject:self.txtMsg.text forKey:@"msg"];
    [_connection sendNetworkPacket:packet];
    
    NSString * msg = [NSString stringWithFormat:@"from %@:%i, %@", _connection.host, _connection.port, self.txtMsg.text]; 
    
    [self displayMessage:msg];
}

#pragma mark - ConnectionDelegate

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
    NSString * currentString = [NSString stringWithFormat:@"%@\n%@", self.msgTextView.text, message];
    [self.msgTextView setText:currentString];
    
    NSRange range = [currentString rangeOfString:message options:NSBackwardsSearch];
    [self.msgTextView scrollRangeToVisible:range];
}


@end
