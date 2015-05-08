//
//  ReceiveOperation.h
//  SocketServer
//
//  Created by  on 12-8-27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiveOperation : NSOperation{
    int _socketNumber;
}

- (id) initWithSocketNumber:(int) socketNumber;

@end
