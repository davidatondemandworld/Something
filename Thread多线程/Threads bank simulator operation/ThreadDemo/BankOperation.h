//
//  BankOperation.h
//  ThreadDemo
//
//  Created by  on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BankOperationDelegate.h"

@interface BankOperation : NSOperation{
    NSString *customer;
}

@property (nonatomic,retain) id<BankOperationDelegate> delegate;

- (id)initWithCustomer:(NSString *) aCustomer;


@end
