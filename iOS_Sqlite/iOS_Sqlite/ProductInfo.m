//
//  ProductInfo.m
//  iOS_Sqlite
//
//  Created by Andy Tung on 13-8-29.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import "ProductInfo.h"

@implementation ProductInfo
-(NSString *)description{
    return [NSString stringWithFormat:@"Id:%i,Name:%@,Price:%f",self.ID,self.name,self.price];
}
@end
