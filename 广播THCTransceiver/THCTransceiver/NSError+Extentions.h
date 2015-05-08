//
//  NSError+Extentions.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define kNotImplementationException @"NotImplementationException"

@interface NSError (Extentions)
+(NSError *)errorWithDomain:(NSString *) domain code:(NSInteger)code errmsg:(NSString *)errmsg innerError:(NSError *) innerError;

@end
