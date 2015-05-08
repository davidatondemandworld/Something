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
    do
    {
        count=recv(_socketNumber, buf, len, 0);  
        NSLog(@"%s",buf);
    }while(strcmp(buf, "exit")!=0);
    
    close(_socketNumber);
}

@end
