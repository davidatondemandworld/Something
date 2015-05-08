//
//  ConnectionDelegate.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-29.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Connection;

@protocol ConnectionDelegate 

- (void) connectionAttemptFailed:(Connection *)connection;
- (void) connectionTerminated:(Connection*)connection;
- (void) receivedNetworkPacket:(NSDictionary*)message viaConnection:(Connection*)connection;


@end
