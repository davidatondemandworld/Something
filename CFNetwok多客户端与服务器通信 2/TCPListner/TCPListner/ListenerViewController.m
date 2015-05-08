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

#pragma mark - sendMsg

-(void)sendMsg:(NSButton *) sender{
    if([self.connectionsTableView numberOfSelectedRows]>0){
        NSDictionary *packet=[NSDictionary dictionaryWithObject:[self.msgTextField stringValue] forKey:@"msg"];
        
        NSInteger row = [self.connectionsTableView selectedRow];
        Connection *connection=[connections objectAtIndex:row];
        [connection sendNetworkPacket:packet]; 
        
        NSString *msg=[NSString stringWithFormat:@"from %@:%li, %@",connection.host,connection.port, [self.msgTextField stringValue]];
        
        [self displayMessage:msg]; 
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
    NSString * msg = [NSString stringWithFormat:@"from %@:%li, %@", connection.peerhost, connection.peerport, [message objectForKey:@"msg"]];
    [self displayMessage:msg];
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
