//
//  BankBusinessSimulatorDelegate.h
//  ThreadDemo
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BankBusinessSimulator;

@protocol BankBusinessSimulatorDelegate <NSObject>
- (void) bankBusinessSimulator:(BankBusinessSimulator *) bankBusinessSimulator willProcessCustomer:(NSString *)customer;

- (void) bankBusinessSimulator:(BankBusinessSimulator *) bankBusinessSimulator processingCustomer:(NSString *)customer;

- (void) bankBusinessSimulator:(BankBusinessSimulator *) bankBusinessSimulator didProcessedCustomer:(NSString *)customer;

@end
