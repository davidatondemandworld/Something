//
//  Article.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-16.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject{
    NSString *_title;
    NSString *_url;
    NSString *_author;
    NSDate *_pubDate;
    NSString *_descriptionText;
    NSString *_descriptionHtml;
    BOOL _detailVisible;
}

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *author;
@property (nonatomic,copy) NSDate *pubDate;
@property (nonatomic,copy) NSString *descriptionText;
@property (nonatomic,readonly,copy) NSString *descriptionHtml;

@property (assign) BOOL detailVisible;

@end
