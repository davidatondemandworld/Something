//
//  TOPHelper.m
//  TaoBaoApi
//
//  Created by  on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TOPHelper.h"

#import <CommonCrypto/CommonDigest.h>


@implementation TOPHelper

+ (NSString *)createMD5:(NSString *)aString{
    const char *utf8string =[aString UTF8String];
    unsigned char array[16];
    CC_MD5(utf8string, strlen(utf8string), array);
    
    NSString *md5str = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",array[0],array[1],array[2],array[3],array[4],array[5],array[6], array[7],array[8],array[9],array[10],array[11],array[12],array[13],array[14],array[15]];
    NSLog(@"------------------------%@",md5str);
    NSLog(@"%s",utf8string);
    return md5str;
}

+ (NSString *)createSign:(NSDictionary *)params
{
    NSArray *keys=[[params allKeys]sortedArrayUsingSelector:@selector(compare:)];
    NSMutableString *sign=[NSMutableString stringWithCapacity:1024];
    [sign appendString:APP_SECRET];    
    for(NSString *key in keys)
    {
        [sign appendFormat:@"%@%@",key,[params objectForKey:key]];
    }
    [sign appendString:APP_SECRET];
    
    return [self createMD5:sign];
}

+ (NSString *)createURL:(NSDictionary *)requestParams{
    NSMutableDictionary *params=[NSMutableDictionary dictionaryWithDictionary:requestParams];
    
    NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *timestamp=[dateFormatter stringFromDate:[NSDate date]];
    
    [params setObject:timestamp forKey:@"timestamp"];    
    [params setObject:APP_KEY forKey:@"app_key"];
    [params setObject:@"2.0" forKey:@"v"];    
    [params setObject:@"md5" forKey:@"sign_method"];  
    [params setObject:[self createSign:params] forKey:@"sign"];
    
    
    NSMutableString *url=[NSMutableString stringWithCapacity:1024];
    [url appendString:SANDBOX_BASE_URL];
    [url appendString:@"?"];    
    for(NSString *key in [params allKeys])
    {
        [url appendFormat:@"%@=%@&",key,[params objectForKey:key]];
    }
    [url replaceCharactersInRange:NSMakeRange([url length]-1, 1) withString:@""];
    
    return [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];   
}

+ (NSData *)sendSynchronousRequest:(NSDictionary *)requestParams{
    NSString *url=[self createURL:requestParams];        
    NSMutableURLRequest *theRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];    
    return [NSURLConnection sendSynchronousRequest:theRequest returningResponse:nil     error:nil];
}








@end
