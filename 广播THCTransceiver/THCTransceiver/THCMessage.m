//
//  THCMessage.m
//  THCTransceiver
//
//  Created by Andy Tung on 13-6-5.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import "THCMessage.h"

@implementation THCMessage

@synthesize type=_type;
@synthesize content=_content;

- (id) initWithType:(THCMessageType)type{
    return [self initWithType:type content:nil];
}
- (id) initWithType:(THCMessageType)type content:(NSData *)content{
    if (self=[super init]) {
        self.type=type;
        self.content=content;
    }
    return self;
}
- (id) initWithData:(NSData *) data{
    if (self=[super init]) {
        NSUInteger len = [data length];
        int size=sizeof(THCMessageType);
        if (len>=size) {
            const void *p=[data bytes];
            memcpy(&_type, p, size);
            p+=size;             
            _content=[[NSData alloc] initWithBytes:p length:len-size];
        }
    }
    return self;
}

- (void)getBytes:(void *)buffer length:(int *)length{
    char *p=(char *)buffer;
    memcpy(p++, &_type, sizeof(_type));
    memcpy(p, [_content bytes], [_content length]);
    *length=(int)[_content length]+1;
}

-(NSString *)description{
    NSString *str=[[[NSString alloc] initWithData:_content encoding:(NSUTF8StringEncoding)] autorelease];
    return [NSString stringWithFormat:@"type:0x%02x;content:%@",_type,str];    
}

@end
