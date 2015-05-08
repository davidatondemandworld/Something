//
//  TcpListnerDelegate.h
//  TCPListner
//
//  Created by apple on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Connection,TCPListner;

@protocol TcpListnerDelegate <NSObject>

// Server has been terminated because of an error
- (void) listnerFailed:(TCPListner *)listner reason:(NSString *)reason;

// Server has accepted a new connection and it needs to be processed
- (void) handleNewConnection:(Connection *)connection;

@end
