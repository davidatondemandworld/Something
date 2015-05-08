//
//  MsgViewController.h
//  TCPClient-Mac
//
//  Created by apple on 12-4-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Connection.h"
#import "ConnectionDelegate.h"


@interface MsgViewController : NSViewController<ConnectionDelegate> {
    Connection *_connection;    
}

@property (nonatomic,retain) IBOutlet NSTextView *msgTextView;
@property (nonatomic,retain) IBOutlet NSTextField *msgTextField;

- (IBAction) sendMsg:(NSButton *) sender;

@end
