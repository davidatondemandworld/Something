//
//  Utility.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Utility.h"
#import "NSError+Extentions.h"

@implementation Utility

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request error:(NSError **)error{    
    NSError *err=nil;   
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&err];    
    if (err!=nil &&error!=NULL) {  
        NSString *errmsg=[NSString stringWithFormat:@"请求数据失败\nURL:%@",[request URL]];
        *error=[NSError errorWithDomain:REQUEST_ERROR_DOMAIN code:kRequestFailed errmsg:errmsg innerError:err];    
    }
    
    return data;
}

+ (void)sendAsynchronousRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData*, NSError*)) handler{  
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse * response, NSData *data, NSError *innerError) {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (innerError!=nil) {
            NSString *errmsg=[NSString stringWithFormat:@"请求数据失败\nURL:%@",[request URL]];
            NSError *error=[NSError errorWithDomain:REQUEST_ERROR_DOMAIN code:kRequestFailed errmsg:errmsg innerError:innerError]; 
            handler(nil,error);
        }
        handler(data,nil);
    }];
}

@end
