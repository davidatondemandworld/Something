//
//  NSDate+Extentions.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Extentions.h"

@implementation NSDate (Extentions)

+(id)dateWithString:(NSString *)string format:(NSString *)format{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];    
    [formatter setDateFormat:format];    
    NSDate *date=[formatter dateFromString:string];
    [formatter release];
    return date;    
}

- (id)stringWithFormat:(NSString *)format{
    NSDateFormatter *formatter=[[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *string=[formatter stringFromDate:self];
    [formatter release];
    return string;
}

@end
