//
//  THCTransceiver.h
//  THCTransceiver
//
//  Created by Andy Tung on 13-6-5.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import <Foundation/Foundation.h>

#define TANSCEIVER_ERROR_DOMAIN @"TANSCEIVER_ERROR_DOMAIN"
#define TANSCEIVER_ERROR_SOCKET_CREATE 1001
#define TANSCEIVER_ERROR_SOCKET_BIND 1002
#define TANSCEIVER_ERROR_RECEIVE 1003
#define TANSCEIVER_ERROR_SEND 1004

enum THCTransceiverState{
    TANSCEIVER_STATE_STOP,
    TANSCEIVER_STATE_STARTED,
    TANSCEIVER_STATE_ONLINE,
    TANSCEIVER_STATE_OFFLINE    
};
typedef enum THCTransceiverState THCTransceiverState;

@class THCMessage;
@class THCIPAddress;
@protocol THCTransceiverDelegate;

@interface THCTransceiver : NSObject{
    id<THCTransceiverDelegate> _delegate;
    THCTransceiverState _state;    
    short _port;
    int _socket;
    NSString *_bindIP;
    NSString *_multicastIP;
    NSData *_identity;
}

@property (nonatomic,assign) id<THCTransceiverDelegate> delegate;
@property (nonatomic,copy) NSData *identity;
@property (nonatomic,readonly) THCTransceiverState state;
@property (nonatomic,readonly) int socket;
@property (nonatomic,readonly) short port;

- (id) initWithPort:(short)port;
- (id) initWithPort:(short)port multicastIP:(NSString *) ip;
- (id) initWithPort:(short)port ip:(NSString *) ip;

- (void) start;
- (void) stop;
- (void) online;
- (void) offline;

- (void) sendMessage:(THCMessage *) msg to:(THCIPAddress *) address;

@end

@protocol THCTransceiverDelegate <NSObject>

- (void) transceiverStartFailed:(NSError *)error;
- (void) transceiver:(THCTransceiver *)transceiver receivedMessage:(THCMessage *) msg from:(THCIPAddress *) address;
- (void) transceiver:(THCTransceiver *)transceiver receivedFailed:(NSError *) error;
- (void) transceiver:(THCTransceiver *)transceiver sendedFailed:(NSError *) error;

@end
