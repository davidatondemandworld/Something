//
//  RSSFormatAnalyzer.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-15.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum{
    kUnknown,
    kRSS,
    kFeed
}RSSFormat;

@interface RSSFormatAnalyzer : NSObject<NSXMLParserDelegate>{
    RSSFormat _format;
}

-(RSSFormat) analyze:(NSData *) data;

@end
