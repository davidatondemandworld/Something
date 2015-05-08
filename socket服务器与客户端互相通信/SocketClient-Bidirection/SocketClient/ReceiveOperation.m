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
        
        struct sockaddr_in addr;
        socklen_t addrLen;
        addrLen = sizeof(addr);
        getsockname(_socketNumber, (struct sockaddr *)&addr, &addrLen);
        int port= ntohs(addr.sin_port);
        
        _directory=[NSString stringWithFormat:@"/tmp/socket/client/%i",port];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:_directory]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_directory withIntermediateDirectories:YES attributes:nil error:nil];
        }        
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
        filname=[NSString stringWithFormat:@"%@/msg_%i",_directory,fno];
        [str writeToFile:filname atomically:YES encoding:(NSASCIIStringEncoding) error:nil];    
        fno++;
    }while(strcmp(buf, "exit")!=0);
    
    close(_socketNumber);
}

@end
