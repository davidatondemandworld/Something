//
//  TCPListnerAppDelegate.m
//  TCPListner
//
//  Created by apple on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TCPListnerAppDelegate.h"
#import "ListenerViewController.h"
#import "Database.h"
@implementation TCPListnerAppDelegate

@synthesize window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [Database createDatabaseIfNotExists];
    ListenerViewController *lvc=[[ListenerViewController alloc] initWithNibName:@"ListenerViewController" bundle:nil];
    
    [self.window setContentView:[lvc view]];
    
    [lvc release];    
}

@end
