//
//  DetailChannel.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-23.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailChannel : NSObject
{
    BOOL _detailVisible;
}
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *pubDate;
@property (nonatomic,copy) NSString *_description;
@property (nonatomic,copy) NSString *link;

@property (assign) BOOL detailVisible;
@end
