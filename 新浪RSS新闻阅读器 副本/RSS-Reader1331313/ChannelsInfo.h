//
//  ChannelsInfo.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-18.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChannelsInfo : NSObject

@property (assign) int _ID;
@property (assign) int _CategoryID;
@property (nonatomic,copy) NSString *_Title;
@property (nonatomic,copy) NSString *_Url;
@property (nonatomic,copy) NSString *_Description;

@end
