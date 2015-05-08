//
//  CategoryInfo.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-17.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryInfo : NSObject{
    int _id;
    NSString *_name;
    int _orderIndex;
}

@property (nonatomic,assign) int ID;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) int orderIndex;

@end
