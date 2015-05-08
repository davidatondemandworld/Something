//
//  Article.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "Article.h"
#import "HtmlTemplate.h"

@implementation Article

- (void)dealloc{
    [_title release];
    [_url release];
    [_author release];
    [_pubDate release];
    [_descriptionText release];
    [_descriptionHtml release];
}

@synthesize title=_title;
@synthesize url=_url;
@synthesize author=_author;
@synthesize pubDate=_pubDate;
@synthesize descriptionText=_descriptionText;
@synthesize descriptionHtml=_descriptionHtml;

@synthesize detailVisible=_detailVisible;

- (void)setDescriptionText:(NSString *)descriptionText{
    [descriptionText retain];
    [_descriptionText release];
    _descriptionText=descriptionText;
    
    [_descriptionHtml release];
    _descriptionHtml = [[[HtmlTemplate sharedTemplate] htmlWithBody:descriptionText] retain];
    NSLog(@"html:%@",_descriptionHtml);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"Article,title:%@,url:%@,author:%@,pubDate:%@,descriptionText:%@,descriptionHtml:%@",_title,_url,_author,_pubDate,_descriptionText,_descriptionHtml];
}

@end
