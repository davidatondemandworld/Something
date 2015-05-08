//
//  TCPListner.h
//  TCPListner
//
//  Created by apple on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TcpListnerDelegate.h"


@interface TCPListner : NSObject {
    id<TcpListnerDelegate>  delegate;
    uint16_t       port;  
    CFSocketRef     listeningSocket;
}

// Delegate receives various notifications about the state of our server
@property(nonatomic, retain) id<TcpListnerDelegate> delegate;

- (id) initWithPort:(uint16_t) aPort;

- (BOOL) start;

- (void) stop;

@end
