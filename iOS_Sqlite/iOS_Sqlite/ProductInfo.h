//
//  ProductInfo.h
//  iOS_Sqlite
//
//  Created by Andy Tung on 13-8-29.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductInfo : NSObject
@property(assign) NSInteger ID;
@property(nonatomic,retain)NSString *name;
@property(assign) float price;
@end
