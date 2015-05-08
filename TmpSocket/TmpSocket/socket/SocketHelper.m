//
//  SocketHelper.m
//  TmpSocket
//
//  Created by BourbonZ on 14/12/11.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import "SocketHelper.h"
static SocketHelper *_socketHelper;

@implementation SocketHelper

+(SocketHelper *)sharedSocket
{
    @synchronized(self)
    {
        if (_socketHelper == nil)
        {
            _socketHelper = [[SocketHelper alloc] init];
            [_socketHelper connectToHost];
            
        }
    }
    
//    static dispatch_once_t predicate;
//    dispatch_once(&predicate, ^{
//        _socketHelper = [[SocketHelper alloc] init];
//        [_socketHelper connectToHost];
//    });

    return _socketHelper;
}
///链接服务器
-(void)connectToHost
{
     _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    NSError *error = nil;
    BOOL connect = [_socket connectToHost:kAddress onPort:12356 withTimeout:3 error:&error];
    if (!connect)
    {
        NSLog(@"%@",error.description);
    }
}
///断开链接
-(void)disConnect
{
    [_socket disconnect];
}
///发送消息
-(void)sendMessage
{
    NSLog(@"发送消息");

    NSString *username = @"18500866433";
    NSString *password = @"123456";
    NSString *str=[NSString stringWithFormat:@"{\"model\":\"login\",\"username\":\"%@\", \"password\":\"%@\"}\n", username,password];
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [_socket writeData:data withTimeout:3 tag:1];
}
///检测链接状态
-(void)connectState
{
    BOOL state = [_socket isConnected];
    if (state)
    {
        NSLog(@"仍在链接");
    }
    else
    {
        NSLog(@"已经断开了");
    }
}
#pragma Mark GCDSocketDelegate
///链接
-(void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    NSLog(@"链接上了服务器");
    [_socket performBlock:^{
        [_socket enableBackgroundingOnSocket];
    }];
    //不写这句话是连不上服务器的
    [sock readDataWithTimeout:3 tag:0];
}
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    NSLog(@"与服务器断开链接:%@",err.description);
    
}

///接受消息
-(void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    NSLog(@"接收到了消息%@",data);
    
    if ([self.delegate respondsToSelector:@selector(receiveMessage:)]&& self.delegate != nil)
    {
        [self.delegate receiveMessage:data];
    }
    
}
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    ///接受超时
    NSLog(@"readError");
    NSTimeInterval time = 3;
    return time;
}
-(NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutWriteWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    ///发送超时
    NSLog(@"writeError");
    return 3;
}
@end
