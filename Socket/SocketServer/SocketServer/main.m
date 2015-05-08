//
//  main.m
//  SocketServer
//
//  Created by apple on 12-3-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#include <sys/socket.h>
#include <netinet/in.h>
#include <unistd.h>
#include <arpa/inet.h>

int main (int argc, const char * argv[])
{
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    BOOL        success;
    int         err;
    int         fd;    
    struct sockaddr_in addr;
    int         port;   
    
    port = 1024;  
    //创建 Socket
    fd = socket(AF_INET, SOCK_STREAM, 0);
    success = (fd != -1);
    
    if (success) {
        NSLog(@"socket success");
        //配置 socket 的绑定地址
        memset(&addr, 0, sizeof(addr));
        addr.sin_len    = sizeof(addr);
        addr.sin_family = AF_INET;
        addr.sin_port   = htons(1024);
        //addr.sin_addr.s_addr = INADDR_ANY;
        addr.sin_addr.s_addr = inet_addr("127.0.0.1");
        //addr.sin_addr.s_addr = inet_addr("192.168.1.101");
        //绑定 Socket
        err = bind(fd, (const struct sockaddr *) &addr, sizeof(addr));
        success = (err == 0);
    }
    if (success) {
        NSLog(@"bind success");
        //启动侦听
        err = listen(fd, 5);
        success = (err == 0);
    }
    if (success) { 
        NSLog(@"listen success");
        //远程地址
        struct sockaddr_in peeraddr;
        int peerfd;
        socklen_t   addrLen;
        addrLen = sizeof(peeraddr);
    
        while(true)
        {
            NSLog(@"prepare accept");
            //接受连接请求
            peerfd = accept(fd, (struct sockaddr *)&peeraddr, &addrLen);
            success = (peerfd!=-1);
            
            if(success){
                NSLog(@"accept success, remote address:%s, port:%i",inet_ntoa(peeraddr.sin_addr),ntohs(peeraddr.sin_port));
                
                char buf[1024];
                ssize_t count;
                size_t len=sizeof(buf);
                do
                {
                    count=recv(peerfd, buf, len, 0);  
                    NSLog(@"%s",buf);
                }while(strcmp(buf, "exit")!=0);             
            } 
            
            close(peerfd);
        }        
    }

    [pool drain];
    return 0;
}

