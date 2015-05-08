//
//  HtmlTemplate.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-17.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HtmlTemplate : NSObject{
    NSString *_htmlTemplate;
}

+ (id) sharedTemplate;
- (NSString *) htmlWithBody:(NSString *) body;

@end
