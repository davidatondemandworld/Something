//
//  main.m
//  SocketClient
//
//  Created by apple on 12-3-23.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <sys/socket.h>
#import <netinet/in.h>
#import <unistd.h>
#import <arpa/inet.h>

int main (int argc, const char * argv[])
{       
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

    BOOL        success;
    int         err;
    int         fd; 
    struct sockaddr_in addr;
    
    fd = socket(AF_INET, SOCK_STREAM, 0);
    success = (fd != -1);   
    
    if (success) {
        NSLog(@"socket success");
        //配置 socket 的绑定地址
        memset(&addr, 0, sizeof(addr));
        addr.sin_len    = sizeof(addr);
        addr.sin_family = AF_INET;
        //addr.sin_port   = htons(1025); 
        addr.sin_addr.s_addr = INADDR_ANY;
        //addr.sin_addr.s_addr = inet_addr("127.0.0.1");
        //addr.sin_addr.s_addr = inet_addr("192.168.1.101");
        //绑定 Socket
        err = bind(fd, (const struct sockaddr *) &addr, sizeof(addr));
        success = (err == 0);
    }
    
    if(success){
        struct sockaddr_in peeraddr;
        memset(&peeraddr, 0, sizeof(peeraddr));
        peeraddr.sin_len    = sizeof(peeraddr);
        peeraddr.sin_family = AF_INET;
        peeraddr.sin_port   = htons(1024);
        peeraddr.sin_addr.s_addr = INADDR_ANY;
        //peeraddr.sin_addr.s_addr = inet_addr("192.168.1.120");
        
        socklen_t addrLen;
        addrLen = sizeof(peeraddr);
        NSLog(@"connecting");
        err = connect(fd, (struct sockaddr *)&peeraddr, addrLen);
        success=(err==0);
        if(success){            
            struct sockaddr_in addr;
            err = getsockname(fd, (struct sockaddr *)&addr, &addrLen);
            success=(err==0);
            if(success){
                NSLog(@"connect success, local address:%s , port:%i",inet_ntoa(addr.sin_addr),ntohs(addr.sin_port));
            }
            if(success){
                char buf[1024]; 
                int offset=4;                
                do
                {
                    printf("input message:");                
                    scanf("%s",buf+offset);                         //输入的内容地址为buf后移4位，
                    int len = (int)strlen(buf+offset);              //len的大小表示的是输入的内容的长度
                    /**
                     *  void *memcpy(void *dest, const void *src, size_t n);
                     *  从源src所指的内存地址的起始位置开始拷贝n个字节到目标dest所指的内存地址的起始位置中
                     */
                    memcpy(buf, &len, offset);                      //把len长度加到buf中，也就是先是内容长度，然后是内容
                    
                    send(fd, buf, len+offset, 0);
                    printf("%s",buf);
                }while(strcmp(buf+offset, "exit")!=0);
            }            
        }
        else{
            NSLog(@"connect failed");
        }        
    }
    
    [pool drain];
    return 0;
}

