//
//  TOPHelper.h
//  TaoBaoApi
//
//  Created by  on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.

//  http://open.taobao.com/doc/detail.htm?id=111

#import <Foundation/Foundation.h>

#define APP_KEY @"test"
#define APP_SECRET @"test"
#define SANDBOX_BASE_URL @"http://gw.api.tbsandbox.com/router/rest"

@interface TOPHelper : NSObject

+ (NSString *) createMD5:(NSString *) aString;

+ (NSString *) createSign:(NSDictionary *) params;

+ (NSString *) createURL:(NSDictionary *) params;

+ (NSData *) sendSynchronousRequest:(NSDictionary *) requestParams;

@end
