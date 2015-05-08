//
//  THCIPAddress.h
//  THCTransceiver
//
//  Created by Andy Tung on 13-6-5.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THCIPAddress : NSObject{
    NSString *_ip;
    short _port;
}

@property (nonatomic,copy) NSString *ip;
@property (nonatomic,assign) short port;

- (id) initWithIP:(NSString *) ip port:(short) port;
- (id) initWithUTF8StringIP:(const char *) ip port:(short) port;

@end
