//
//  ListenerViewController.h
//  TCPListner
//
//  Created by apple on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TcpListnerDelegate.h"
#import "ConnectionDelegate.h"
#import "TCPListner.h"


@interface ListenerViewController : NSViewController <TcpListnerDelegate,ConnectionDelegate, NSTableViewDataSource> {   
    
    NSMutableArray *connections;
    BOOL isListning;    
}

@property (nonatomic,retain) IBOutlet NSTableView *connectionsTableView;
@property (nonatomic,retain) IBOutlet NSTextView *msgTextView;
@property (nonatomic,retain) IBOutlet NSTextField *msgTextField;

@property (nonatomic,retain) TCPListner *listner;

- (IBAction) startOrStop:(NSButton *) sender;


@end
