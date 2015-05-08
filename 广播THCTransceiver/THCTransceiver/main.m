//
//  main.m
//  THCTransceiver
//
//  Created by Andy Tung on 13-6-5.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import <Foundation/Foundation.h>

#import "THCTransceiver.h"
#import "THCMessage.h"
#import "THCIPAddress.h"

@interface Main : NSObject<THCTransceiverDelegate>

- (void) testWithIp:(NSString *)ip port:(short) port name:(NSString *) name;
- (void) thread_main:(id)info;

@end



@implementation Main

- (void) testWithIp:(NSString *)ip port:(short) port name:(NSString *)name{
    NSInteger n=[[ip substringWithRange:NSMakeRange(0, 3)] integerValue];
    THCTransceiver *transceiver=nil;
    if (n==239) {
        transceiver=[[THCTransceiver alloc] initWithPort:port multicastIP:ip];
        
    }else{
        transceiver=[[THCTransceiver alloc] initWithPort:port ip:ip];
    }    
    
    transceiver.delegate=self;
    transceiver.identity=[name dataUsingEncoding:NSUTF8StringEncoding];
    [transceiver start];
    
    [NSThread detachNewThreadSelector:@selector(thread_main:) toTarget:self withObject:transceiver];   
    
    [[NSRunLoop currentRunLoop] run];  
}

- (void) transceiverStartFailed:(NSError *)error{
    NSLog(@"transceiverStartFailed:%@",error);
}
- (void) transceiver:(THCTransceiver *)transceiver receivedMessage:(THCMessage *) msg from:(THCIPAddress *) address{
    NSLog(@"receivedMessage:%@ from:%@",msg,address);
    if (msg.type== MESSAGE_TYPE_QUERY) {
        THCMessage *rmsg=[[[THCMessage alloc] initWithType:MESSAGE_TYPE_IDENTITY] autorelease];
        rmsg.content=transceiver.identity;
        [transceiver sendMessage:rmsg to:address];
    }
}
- (void) transceiver:(THCTransceiver *)transceiver receivedFailed:(NSError *) error{
    NSLog(@"receivedFailed:%@",error);
}
- (void) transceiver:(THCTransceiver *)transceiver sendedFailed:(NSError *) error{
    NSLog(@"sendedFailed:%@",error);
}


- (void) thread_main:(id)info{    
    THCTransceiver *transceiver=(THCTransceiver *)info;
    char ipbuf[16];
    char msgbuf[256];
    int msgtype=0;
    THCIPAddress *addr;
    THCMessage *msg;
    do {
        printf("\nInput ip message(format:<message type> <message content> <target ip>)\n");
        printf("\tmessage type(0x00:UNKNOW,0x10:QUERY,0x20:IDENTITY,0x30:ONLINE,0x40:OFFLINE,0x50:TEXT)\n");
        printf("\tmessage type(0:UNKNOW,16:QUERY,32:IDENTITY,48:ONLINE,64:OFFLINE,80:TEXT)\n");
        scanf("%i %s %s",&msgtype,msgbuf,ipbuf);     
                
        addr=[[THCIPAddress alloc] initWithUTF8StringIP:ipbuf port:transceiver.port];
        msg=[[THCMessage alloc] initWithType:msgtype content:[NSData dataWithBytes:msgbuf length:strlen(msgbuf)+1]];        
        NSLog(@"will send %@,%@",msg,addr);
        if (msg.type==MESSAGE_TYPE_ONLINE) {
            [transceiver online];
        }else if(msg.type==MESSAGE_TYPE_OFFLINE){
            [transceiver offline];
        }else{
            [transceiver sendMessage:msg to:addr];
        }
        [addr release];
        [msg release];
        
    } while (transceiver.state != TANSCEIVER_STATE_STOP);
}

@end

int main(int argc, const char * argv[])
{
    //argc=4;
    if (argc!=4) {
        printf("\nFormat: transceiver <name> <ip> <port>");
        printf("\nUse ip 239.x.x.x for multicast,or 192.x.x.x for bind\n");
        return -1;
    }  
    
    @autoreleasepool {        
        Main *app=[[[Main alloc] init] autorelease];
        NSString *name=[NSString stringWithUTF8String:argv[1]];
        NSString *ip=[NSString stringWithUTF8String:argv[2]];
        short port=atoi(argv[3]);
//      NSString *name=@"andy";
//      NSString *ip=@"192.168.70.111";
//      short port=8000;
        [app testWithIp:ip port:port name:name];
    }
    return 0;
}

