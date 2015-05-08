//
//  RSSDatabase.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-18.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteDatabase.h"
@class CategoryInfo,ChannelsInfo,Articles;

@interface RSSDatabase : NSObject
{
    SqliteDatabase *sqliteDatabase;
}
+(void) createDatabaseIfNotExists;
+(NSString *) filename;
+(RSSDatabase *) sharedDatabase;
@end

@interface RSSDatabase (RSSProvider)

-(int) addChannel:(ChannelsInfo *) aChannel error:(NSError **)error;
-(int) deleteChannel:(ChannelsInfo *)aChannel error:(NSError **)error;

-(int) addCategory:(CategoryInfo *) aCategory error:(NSError **)error;
-(int) updateCategory:(CategoryInfo *)aCategory to:(CategoryInfo *)bCategory error:(NSError **)error;
-(int) deleteCategory:(CategoryInfo *)aCategory error:(NSError **)error;

-(int) addArticle:(Articles *) aArticle error:(NSError **)error;
-(int) deleteArticle:(Articles *)aArticle error:(NSError **)error;

-(NSArray *)selectAllCategory;
-(NSArray *)selectAllChannels;
-(NSArray *)selectAllArticles;

-(NSMutableArray *)selectChannelByCategoryId:(int) categoryId;
-(NSMutableArray *)selectChannelByTitle:(NSString *) title;
-(NSMutableArray *)selectArticleByTitle:(NSString *) title;

@end
