//
//  Utility.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface Utility : NSObject

+ (NSData *) sendSynchronousRequest:(NSURLRequest *) request error:(NSError **) error;

+ (void)sendAsynchronousRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData*data, NSError*error)) handler;

@end
