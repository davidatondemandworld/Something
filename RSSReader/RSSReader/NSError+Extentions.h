//
//  NSError+Extentions.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define REQUEST_ERROR_DOMAIN @"REQUEST_ERROR_DOMAIN"
#define PARSING_ERROR_DOMAIN @"PARSING_ERROR_DOMAIN"

#define kRequestFailed 1001
#define kUnknownRSSFormat 1002
#define kParseRSSXmlFailed 1003

#define kNotImplementationException @"NotImplementationException"

@interface NSError (Extentions)
+(NSError *)errorWithDomain:(NSString *) domain code:(NSInteger)code errmsg:(NSString *)errmsg innerError:(NSError *) innerError;
-(void) show;
@end
