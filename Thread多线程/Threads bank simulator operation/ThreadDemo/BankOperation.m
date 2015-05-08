//
//  BankOperation.m
//  ThreadDemo
//
//  Created by  on 12-11-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BankOperation.h"

@implementation BankOperation

@synthesize delegate;

- (id)initWithCustomer:(NSString *)aCustomer{
    self=[super init];
    if (self) {
        customer=[aCustomer copy];
    }
    return self;
}

- (void)main{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
    if (self.delegate != nil) {
        [self.delegate bankOperation:self willProcessCustomer:customer]; 
    }               
    //模拟准备
    [NSThread sleepForTimeInterval:0.1];
    if (self.delegate !=nil) {
        [self.delegate bankOperation:self processingCustomer:customer];
    }
    //模拟正在处理
    [NSThread sleepForTimeInterval:0.5];
    //处理完了
    if (self.delegate !=nil) {
        [self.delegate bankOperation:self didProcessedCustomer:customer];
    }         
    [NSThread sleepForTimeInterval:0.3];        
    
    [pool release];
} 

@end
