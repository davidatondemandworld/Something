//
//  BankBusinessSimulator.m
//  ThreadDemo
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BankBusinessSimulator.h"

@interface BankBusinessSimulator()
- (void) thread_main;
@end

@implementation BankBusinessSimulator

@synthesize delegate;

- (id)init{
    self=[super init];
    if (self) {            
    }
    return self;
}

- (void)enqueueCustomer:(NSString *)customer{  
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0);
    dispatch_async(queue, ^{
        NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];
        if (self.delegate != nil) {
            [self.delegate bankBusinessSimulator:self willProcessCustomer:customer]; 
        }               
        //模拟准备
        [NSThread sleepForTimeInterval:0.1];
        if (self.delegate !=nil) {
            [self.delegate bankBusinessSimulator:self processingCustomer:customer];
        }
        //模拟正在处理
        [NSThread sleepForTimeInterval:0.5];
        //处理完了
        if (self.delegate !=nil) {
            [self.delegate bankBusinessSimulator:self didProcessedCustomer:customer];
        }         
        [NSThread sleepForTimeInterval:0.3];        
        
        [pool release]; 
    });
}

@end
