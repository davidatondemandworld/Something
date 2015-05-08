//
//  HtmlTemplate.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-17.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "HtmlTemplate.h"

static HtmlTemplate *sharedInstance=nil;

@implementation HtmlTemplate

- (id)init{
    if (self=[super init]) {
        NSString *filename=[[NSBundle mainBundle] pathForResource:@"html" ofType:@"tmpl"];
        NSData *data=[NSData dataWithContentsOfFile:filename];
        _htmlTemplate=[[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
    }
    return self;
}

- (void)dealloc{
    [_htmlTemplate release];
}

+ (id)sharedTemplate{
    if (sharedInstance==nil) {
        sharedInstance=[[[self class] alloc] init];
    }
    return sharedInstance;
}

- (NSString *)htmlWithBody:(NSString *)body{
    return [NSString stringWithFormat:_htmlTemplate,body];
}

@end
