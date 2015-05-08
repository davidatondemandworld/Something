//
//  THCIPAddress.m
//  THCTransceiver
//
//  Created by Andy Tung on 13-6-5.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import "THCIPAddress.h"

@implementation THCIPAddress

@synthesize ip=_ip;
@synthesize port=_port;

- (id)initWithIP:(NSString *)ip port:(short)port{
    if (self=[super init]) {
        _ip=[ip copy];
        _port=port;
    }
    return self;
}

- (id)initWithUTF8StringIP:(const char *)ip port:(short)port{
    NSString *str=[NSString stringWithUTF8String:ip];
    return [self initWithIP:str port:port];
}

- (NSString *)description{   
    NSString *str = [NSString stringWithFormat:@"%@:%i",_ip,_port];    
    return str;
    //return [NSString stringWithFormat:@"%@",_ip];
}

@end
