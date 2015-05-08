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

@synthesize delegate,state;

- (id)init{
    self=[super init];
    if (self) {
        customersQueue=[[NSMutableArray alloc] initWithCapacity:50];
        threads=[[NSMutableArray alloc] initWithCapacity:3];        
        state=0;
        
        NSThread *thread;
        for (int i=0; i<3; i++) {
            thread=[[NSThread alloc] initWithTarget:self selector:@selector(thread_main) object:nil];
            [thread setName:[NSString stringWithFormat:@"window_%i",i+1]];
            [threads addObject:thread];
            [thread release];
        }
    }
    return self;
}

- (void)enqueueCustomer:(NSString *)customer{
    //NSCondition *condition=[[NSCondition alloc] init];
//    [condition lock];    
//    [customersQueue addObject:customer]; 
//    [condition unlock];
    
    @synchronized(customersQueue){         
        [customersQueue addObject:customer];        
    }
}

- (NSString *)dequeueCustomer{
    @synchronized(customersQueue){
        NSString *customer=nil;
        if ([customersQueue count]>0) {
            customer=[[customersQueue objectAtIndex:0] retain];//如果不 retain remove可能立即释放内存
            [customersQueue removeObjectAtIndex:0];
        }
        return [customer autorelease];
    }
}

- (void)thread_main{
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc] init];    
    
    NSString *customer=nil;
    NSString *windowName=[[NSThread currentThread] name];
    while (state==1) {
        customer=[self dequeueCustomer];
        if (customer!=nil) {  
            
            if (self.delegate !=nil) {
                [self.delegate bankBusinessSimulator:self willProcessCustomer:customer onWindow:windowName];
            }
            //模拟准备
            [NSThread sleepForTimeInterval:0.1];
            
            if (self.delegate !=nil) {
                [self.delegate bankBusinessSimulator:self processingCustomer:customer onWindow:windowName];
            }
            //模拟正在处理
            [NSThread sleepForTimeInterval:0.5];
            //处理完了
            if (self.delegate !=nil) {
                [self.delegate bankBusinessSimulator:self didProcessedCustomer:customer onWindow:windowName];
            }            
        }
        
        [NSThread sleepForTimeInterval:0.3];
    }
    
    [pool release];    
}

- (void)start{
    if (state==0) {  
        state=1;
        for (NSThread *thread in threads) {
            [thread start];
        }
        if (self.delegate !=nil) {
            [self.delegate bankBusinessSimulatorDidStart:self];
        }
    }
}

- (void) stop{
    if (state==1) {
        state=2;
        if (self.delegate !=nil) {
            [self.delegate bankBusinessSimulatorDidFinished:self];
        }
    }
}

@end
