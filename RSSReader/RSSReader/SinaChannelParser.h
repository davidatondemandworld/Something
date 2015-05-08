//
//  SinaChannelParser.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ChannelSourceParsing.h"

@interface SinaChannelParser : NSObject<ChannelSourceParsing,NSXMLParserDelegate>{
    NSMutableDictionary *channelsDict;
    NSMutableArray *channelsArray;    
    NSMutableString *currentElementName;
}

@end
