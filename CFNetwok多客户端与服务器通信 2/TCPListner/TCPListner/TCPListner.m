//
//  TCPListner.m
//  TCPListner
//
//  Created by apple on 12-4-5.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "TCPListner.h"
#import "Connection.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>

@implementation TCPListner

@synthesize delegate;

#pragma mark - Lifecycle

- (id)initWithPort:(uint16_t) aPort{
    if((self = [super init])){
        port = aPort; 
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
}

#pragma mark - Accept Callbacks

// This function will be used as a callback while creating our listening socket via 'CFSocketCreate'
static void acceptCallback(CFSocketRef socket, CFSocketCallBackType type, CFDataRef address, const void *data, void *info)
{
    // We can only process "connection accepted" calls here
    if ( type != kCFSocketAcceptCallBack ) {
        return;
    }
    
    // for an AcceptCallBack, the data parameter is a pointer to a CFSocketNativeHandle
    CFSocketNativeHandle nativeSocketHandle = *(CFSocketNativeHandle *)data;
    
    Connection* connection = [[[Connection alloc] initWithNativeSocketHandle:nativeSocketHandle] autorelease];
    
    // In case of errors, close native socket handle
    if ( connection == nil ) {
        close(nativeSocketHandle);
        return;
    }
    
    // finish connecting
    BOOL succeed = [connection connect];
    if ( !succeed ) {
        [connection close];
        return;
    } 
    
    // Pass this on to our delegate
    TCPListner *listner = (TCPListner *)info;
    if(listner.delegate){
       [listner.delegate handleNewConnection:connection];   
    }
}

#pragma mark - start and stop listen

- (BOOL)start{    
    BOOL        success;
    int         err;
    int         sock;    
    struct sockaddr_in addr;   
    
    //创建 Socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    success = (sock != -1);    
    if (success) NSLog(@"create socket success");
    
    //绑定 Socket
    if (success) {       
        //配置 socket 的绑定地址
        memset(&addr, 0, sizeof(addr));
        addr.sin_len    = sizeof(addr);
        addr.sin_family = AF_INET;
        addr.sin_port   = htons(port);
        //addr.sin_addr.s_addr = INADDR_ANY;
        //addr.sin_addr.s_addr = inet_addr("127.0.0.1");
        addr.sin_addr.s_addr = inet_addr("192.168.1.102");
        
        //绑定 Socket
        err = bind(sock, (const struct sockaddr *) &addr, sizeof(addr));
        success = (err == 0);
        
        if (success) NSLog(@"bind success");
    }
    
    //侦听 Socket
    if (success) {        
        //启动侦听
        err = listen(sock, 5);
        success = (err == 0);
        
        if (success) NSLog(@"listen success");
    }
    
    //创建 CFSocket
    if (success) { 
        CFSocketContext context = { 0, self, NULL, NULL, NULL };    
        
        listeningSocket = CFSocketCreateWithNative(NULL,sock,kCFSocketAcceptCallBack,acceptCallback,&context);
        success = (listeningSocket != NULL);        
    }
    
    //创建 CFRunLoopSource 并加入当前 RunLoop
    if (success) {
        CFRunLoopSourceRef  rls = CFSocketCreateRunLoopSource(NULL, listeningSocket, 0);
        assert(rls != NULL);
        
        CFRunLoopAddSource(CFRunLoopGetCurrent(), rls, kCFRunLoopDefaultMode);
        
        CFRelease(rls);
    }    
    
    return success;
}

- (void)stop{
    if ( listeningSocket != nil ) {
        CFSocketInvalidate(listeningSocket);
		CFRelease(listeningSocket);
		listeningSocket = nil;
    }
}
@end
