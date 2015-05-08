//
//  BankBusinessSimulatorDelegate.h
//  ThreadDemo
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BankOperation;

@protocol BankOperationDelegate <NSObject>
- (void) bankOperation:(BankOperation *) bankOperation willProcessCustomer:(NSString *)customer;

- (void) bankOperation:(BankOperation *) bankOperation processingCustomer:(NSString *)customer;

- (void) bankOperation:(BankOperation *) bankOperation didProcessedCustomer:(NSString *)customer;

@end
