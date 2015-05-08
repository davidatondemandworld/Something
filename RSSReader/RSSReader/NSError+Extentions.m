//
//  NSError+Extentions.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "NSError+Extentions.h"

@implementation NSError (Extentions)

+ (NSError *)errorWithDomain:(NSString *)domain code:(NSInteger)code errmsg:(NSString *)errmsg innerError:(NSError *)innerError{
    
    NSArray *objArray;
    NSArray *keyArray;
    if (innerError==nil) {
        objArray=[NSArray arrayWithObjects:errmsg, nil];
        keyArray=[NSArray arrayWithObjects:NSLocalizedDescriptionKey, nil];
    }
    else{
        
        objArray=[NSArray arrayWithObjects:errmsg,innerError, nil];
        keyArray=[NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];                
    }
    NSDictionary *eDict=[NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
    
    return [[[NSError alloc] initWithDomain:domain code:code userInfo:eDict] autorelease];    
}

- (void)show{    
    NSString *msg=[self localizedDescription];    
    UIAlertView *alertView=[[[UIAlertView alloc] initWithTitle:@"错误消息" message:msg delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil] autorelease];
    [alertView show];
}

@end
