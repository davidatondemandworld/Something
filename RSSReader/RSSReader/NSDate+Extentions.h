//
//  NSDate+Extentions.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extentions)

+(id) dateWithString:(NSString *) string format:(NSString *)format;
-(id) stringWithFormat:(NSString *)format;

@end
