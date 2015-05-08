//
//  RSSManager.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-18.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#define BUSINESS_ERROR_DOMAIN @"BUSINESS_ERROR_DOMAIN"
@class CategoryInfo,ChannelsInfo,Articles;
@interface RSSManager : NSObject
{
    NSMutableArray *allCategory;
    NSMutableArray *allChannel;
    NSMutableArray *allArticles;
}
+(RSSManager *)defaultManager;
-(NSMutableArray *)allCategory;
-(NSMutableArray *)allChannell;
-(NSMutableArray *)allArticles;

-(NSMutableArray *)selectChannelByCategoryId:(int) categoryId;
-(NSMutableArray *)selectChannelByTitle:(NSString *) title;
-(NSMutableArray *)selectArticleByTitle:(NSString *) title;


-(int)addCategory:(CategoryInfo *) aCategory error:(NSError **)error;
-(int)updateCategory:(CategoryInfo *)aCategory to:(CategoryInfo *)bCategoryo error:(NSError **)error;
-(int)deleteCategory:(CategoryInfo *)aCategory error:(NSError **)error;

-(int)addChannel:(ChannelsInfo *)aChannel error:(NSError **)error;
-(int)deleteChannel:(ChannelsInfo *)aChannel error:(NSError **)error;

-(int)addArticle:(Articles *)aArticle error:(NSError **)error;
-(int)deleteArticle:(Articles *)aArticle error:(NSError **)error;

@end
