//
//  ReceiveOperation.m
//  SocketServer
//
//  Created by  on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ReceiveOperation.h"

#import <sys/socket.h>
#import <netinet/in.h>
#import <unistd.h>
#import <arpa/inet.h>

@implementation ReceiveOperation

@synthesize port;

- (id)initWithSocketNumber:(int)socketNumber{
    self=[super init];
    if (self) {
        _socketNumber=socketNumber;
    }
    return self;
}

- (void)main{
    char buf[1024];
    ssize_t count;
    size_t len=sizeof(buf);
    NSString *str;
    NSString *filname;
    int fno=0;
    do
    {
        count=recv(_socketNumber, buf, len, 0); 
        str=[NSString stringWithCString:buf encoding:(NSASCIIStringEncoding)];
        filname=[NSString stringWithFormat:@"/tmp/socket/server/msg_%i",fno];
        [str writeToFile:filname atomically:YES encoding:(NSASCIIStringEncoding) error:nil];  
        fno++;
    }while(strcmp(buf, "exit")!=0);
    
    close(_socketNumber);
}

@end
