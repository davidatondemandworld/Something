//
//  TCPClient_MacAppDelegate.m
//  TCPClient-Mac
//
//  Created by apple on 12-4-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TCPClient_MacAppDelegate.h"
#import "MsgViewController.h"

@implementation TCPClient_MacAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    MsgViewController *msgvc=[[MsgViewController alloc] initWithNibName:@"MsgViewController" bundle:nil];
    
    [self.window setContentView:[msgvc view]];

}

@end
