//
//  SocketHelper.h
//  TmpSocket
//
//  Created by BourbonZ on 14/12/11.
//  Copyright (c) 2014年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"

@protocol socketDelegate <NSObject>

-(void)receiveMessage:(NSData *)data;

@end
@interface SocketHelper : NSObject<GCDAsyncSocketDelegate>
{
    GCDAsyncSocket *_socket;
}
@property (nonatomic,assign) id<socketDelegate>delegate;
+(SocketHelper *)sharedSocket;
///发送消息
-(void)sendMessage;
///断开链接
-(void)disConnect;
///链接服务器
-(void)connectToHost;
///检测链接状态
-(void)connectState;
@end

