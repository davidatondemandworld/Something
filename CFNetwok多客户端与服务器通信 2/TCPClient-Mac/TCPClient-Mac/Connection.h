//
//  Connection.h
//  TCPListner
//
//  Created by apple on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "ConnectionDelegate.h"


@interface Connection : NSObject
{
    id<ConnectionDelegate>  delegate;
    
    // Connection info: host address and port
    NSString *              host;
    NSInteger               port;
    NSString *              peerhost;
    NSInteger               peerport;
    
    // Connection info: native socket handle
    CFSocketNativeHandle    connectedSocketHandle;    
        
    // Read stream
    CFReadStreamRef         readStream;
    BOOL                    readStreamOpen;
    NSMutableData *         incomingDataBuffer;
    int	                    packetBodySize;

    // Write stream
    CFWriteStreamRef        writeStream;
    BOOL                    writeStreamOpen;
    NSMutableData *         outgoingDataBuffer;
}

@property(nonatomic, retain) id<ConnectionDelegate> delegate;
@property(nonatomic, retain) NSString * host;
@property(nonatomic, assign) NSInteger port;
@property(nonatomic, retain) NSString * peerhost;
@property(nonatomic, assign) NSInteger peerport;

- (id) initWithHostAddress:(NSString *) thePeerHost andPort:(NSInteger) thePort;

// Initialize using a native socket handle, assuming connection is open
- (id) initWithNativeSocketHandle:(CFSocketNativeHandle)nativeSocketHandle;

// Connect using whatever connection info that was passed during initialization
- (BOOL) connect;

// Close connection
- (void) close;

// Send network message
- (void) sendNetworkPacket:(NSDictionary *)packet;

@end
