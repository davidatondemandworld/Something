//
//  THCTransceiver.m
//  THCTransceiver
//
//  Created by Andy Tung on 13-6-5.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import "THCTransceiver.h"
#import "THCMessage.h"
#import "THCIPAddress.h"
#import "NSError+Extentions.h"

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>

static void receiveWork(void * info);

@implementation THCTransceiver

@synthesize delegate=_delegate;
@synthesize identity=_identity;
@synthesize port=_port;
@synthesize state=_state;
@synthesize socket=_socket;

- (id)initWithPort:(short)port{
    if (self=[super init]) {
        _port=port;
        _state= TANSCEIVER_STATE_STOP;
    }
    return self;
}

- (id)initWithPort:(short)port multicastIP:(NSString *)ip{
    if (self=[self initWithPort:port]) {
        _multicastIP=[ip copy];
    }
    return self;
}

- (id)initWithPort:(short)port ip:(NSString *)ip{
    if (self=[self initWithPort:port]) {
        _bindIP=[ip copy];
        _multicastIP=@"239.1.2.3";//设置默认组播地址
    }
    return self;
}

- (void)start{
    if (_state!=TANSCEIVER_STATE_STOP) {
        NSLog(@"Transceiver is already started");
        return;
    }
    
    BOOL        success;
    int         err;    
    struct sockaddr_in addr;   
    //创建 Socket
    _socket = socket(AF_INET, SOCK_DGRAM, 0);
    success = (_socket != -1);
    
    if (!success) {
        NSLog(@"create socket failed");
        if (_delegate!=nil) {
            [_delegate transceiverStartFailed:[NSError errorWithDomain:TANSCEIVER_ERROR_DOMAIN code:TANSCEIVER_ERROR_SOCKET_CREATE errmsg:@"create socket failed" innerError:nil]];
        }
        return;
    }    
    
    NSLog(@"socket success");
    
    //配置 socket 的绑定地址
    memset(&addr, 0, sizeof(addr));
    addr.sin_len    = sizeof(addr);
    addr.sin_family = AF_INET;
    addr.sin_port   = htons(_port);
    if (_bindIP!=nil) {
        addr.sin_addr.s_addr = inet_addr([_bindIP UTF8String]);
    }else{
        addr.sin_addr.s_addr = INADDR_ANY;
    }
    
    //绑定 Socket
    err = bind(_socket, (const struct sockaddr *) &addr, sizeof(addr));
    success = (err == 0);
    
    if (!success) {
        NSLog(@"bind socket failed");
        if (_delegate!=nil) {
            [_delegate transceiverStartFailed:[NSError errorWithDomain:TANSCEIVER_ERROR_DOMAIN code:TANSCEIVER_ERROR_SOCKET_BIND errmsg:@"bind socket failed" innerError:nil]];
        }
        return;
    }
    
    NSLog(@"bind success");
    
    dispatch_async_f(dispatch_get_current_queue(), self, receiveWork); 
    
    _state = TANSCEIVER_STATE_STARTED;
}

- (void)stop{
    _state = TANSCEIVER_STATE_STOP;
    if (_socket>0) {
        close(_socket);
        _socket=-1;
    }    
}

- (void)online{
    if (_state!=TANSCEIVER_STATE_ONLINE && _multicastIP !=nil) {
        //change state
        _state=TANSCEIVER_STATE_ONLINE;
        //join multicast ip
        struct ip_mreq mreq;
        mreq.imr_multiaddr.s_addr = inet_addr([_multicastIP UTF8String]);
        mreq.imr_interface.s_addr = INADDR_ANY;
        setsockopt(_socket, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq, sizeof(mreq));
        //send online message        
        THCIPAddress *address=[[THCIPAddress alloc] initWithIP:_multicastIP port:_port];
        THCMessage *msg=[[THCMessage alloc] initWithType:MESSAGE_TYPE_ONLINE content:_identity];
        [self sendMessage:msg to:address];
        [msg release];
        [address release];        
    }   
}

- (void)offline{
    if (_state!=TANSCEIVER_STATE_OFFLINE  && _multicastIP !=nil) {
        //change state
        _state=TANSCEIVER_STATE_OFFLINE;
        //send offline message
        THCIPAddress *address=[[THCIPAddress alloc] initWithIP:_multicastIP port:_port];
        THCMessage *msg=[[THCMessage alloc] initWithType:MESSAGE_TYPE_OFFLINE content:_identity];
        [self sendMessage:msg to:address];
        [msg release];
        [address release];
        //drop multicast ip
        struct ip_mreq mreq;
        mreq.imr_multiaddr.s_addr = inet_addr([_multicastIP UTF8String]);
        mreq.imr_interface.s_addr = INADDR_ANY;
        setsockopt(_socket, IPPROTO_IP, IP_DROP_MEMBERSHIP, &mreq, sizeof(mreq));      
    }
}

- (void)sendMessage:(THCMessage *)msg to:(THCIPAddress *)address{   
    
    struct sockaddr_in peeraddr;
    socklen_t addrLen;
    ssize_t count=-1;
    char buf[1024];
    int len=0;

    memset(&peeraddr, 0, sizeof(peeraddr));
    peeraddr.sin_len    = sizeof(peeraddr);
    peeraddr.sin_family = AF_INET;
    peeraddr.sin_port   = htons(address.port);    
    peeraddr.sin_addr.s_addr = inet_addr([address.ip UTF8String]);
    addrLen = sizeof(peeraddr);
    
    [msg getBytes:buf length:&len]; 
    
    count = sendto(_socket, buf, len, 0, (struct sockaddr *)&peeraddr, addrLen);
    if (count==-1) {
        NSLog(@"send msg failed");
        if (_delegate!=nil) {
            [_delegate transceiver:self sendedFailed:[NSError errorWithDomain:TANSCEIVER_ERROR_DOMAIN code:TANSCEIVER_ERROR_SEND errmsg:@"send msg  failed" innerError:nil]];
        }
    }
}

static void receiveWork(void * info){
    @autoreleasepool {
        NSLog(@"receive working");
        THCTransceiver *transceiver=(THCTransceiver *)info;
        id<THCTransceiverDelegate> delegate=transceiver.delegate;
        //远程地址
        struct sockaddr_in peeraddr;
        memset(&peeraddr, 0, sizeof(peeraddr));
        socklen_t addrLen=sizeof(peeraddr);
        
        char buf[1024];
        ssize_t count;
        size_t len=sizeof(buf);
        
        do
        {
            @autoreleasepool {                
                count = recvfrom(transceiver.socket, buf, len, 0, (struct sockaddr *)&peeraddr, &addrLen);                
                
                if (count==-1) {
                    NSLog(@"receive failed!");
                    if (delegate!=nil) {
                        [delegate transceiver:transceiver receivedFailed:[NSError errorWithDomain:TANSCEIVER_ERROR_DOMAIN code:TANSCEIVER_ERROR_RECEIVE errmsg:@"receive failed" innerError:nil]];
                    }
                }
                
                if (count>0) {
                    NSLog(@"%s from address:%s , port:%i",buf+sizeof(THCMessageType),inet_ntoa(peeraddr.sin_addr),htons(peeraddr.sin_port));
                    
                    NSData *data=[NSData dataWithBytes:buf length:count];
                    THCMessage *msg=[[[THCMessage alloc] initWithData:data] autorelease];
                    THCIPAddress *address=[[[THCIPAddress alloc] initWithUTF8StringIP:inet_ntoa(peeraddr.sin_addr) port:htons(peeraddr.sin_port)] autorelease];
                    
                    if (delegate !=nil) {
                        [delegate transceiver:transceiver receivedMessage:msg from:address];
                    }
                }
            }
            
        }while(transceiver.state != TANSCEIVER_STATE_STOP);
    }
}

@end
