//
//  ServerSocket.h
//  TeskSocket
//
//  Created by apple on 13-5-24.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncSocket.h"
@interface ServerSocket : NSObject <AsyncSocketDelegate>
{
    AsyncSocket *listenSocket;
    NSMutableArray *connectedSockets;
    
    BOOL isRunning;
}
@property (nonatomic,assign) NSUInteger selectA;//中国
@property (nonatomic,assign) NSUInteger selectB;//日本
@property (nonatomic,assign) NSUInteger selectC;//英国
@property (nonatomic,assign) NSUInteger selectD;//美国
@property (nonatomic,retain) NSMutableString *result;
- (void)lock;
- (void)unlock;
- (void)sendMessage;

- (void)startListen;
- (void)stopListen;

- (void)shareScreen;
- (void)stopShareScreen;
- (void)writeScreen:(NSData *)imageData;
- (void)stopWriteScreen;
@end
