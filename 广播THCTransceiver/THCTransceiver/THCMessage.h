//
//  THCMessage.h
//  THCTransceiver
//
//  Created by Andy Tung on 13-6-5.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import <Foundation/Foundation.h>

enum THCMessageType:Byte{
    MESSAGE_TYPE_UNKNOWN = 0x00,
    MESSAGE_TYPE_QUERY = 0x10,
    MESSAGE_TYPE_IDENTITY = 0x20,
    MESSAGE_TYPE_ONLINE = 0x30,
    MESSAGE_TYPE_OFFLINE = 0x40,
    MESSAGE_TYPE_TEXT = 0x50
};
typedef enum THCMessageType THCMessageType;

@interface THCMessage : NSObject{
    THCMessageType _type;
    NSData *_content;
}

- (id) initWithType:(THCMessageType)type;
- (id) initWithType:(THCMessageType)type content:(NSData *)content;
- (id) initWithData:(NSData *) data;

@property (nonatomic,assign) THCMessageType type;
@property (nonatomic,copy) NSData *content;

- (void) getBytes:(void *) buffer length:(int *)length;

@end
