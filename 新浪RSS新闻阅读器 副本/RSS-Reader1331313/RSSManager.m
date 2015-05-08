//
//  RSSManager.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-18.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "RSSManager.h"
#import "RSSDatabase.h"
#import "CategoryInfo.h"
#import "ChannelsInfo.h"
#import "Articles.h"

static RSSManager *staticRSSManager;

@implementation RSSManager
+(RSSManager *)defaultManager
{
    if(staticRSSManager == nil)
    {
        staticRSSManager = [[RSSManager alloc] init];
    }
    return staticRSSManager;
}

-(NSMutableArray *)allCategory
{
    if(allCategory == nil)
    {
        NSArray *array = [[RSSDatabase sharedDatabase] selectAllCategory];
        allCategory = [[NSMutableArray alloc] initWithArray:array];
    }
    return allCategory;
}
-(NSMutableArray *)allChannell
{
    if(allChannel == nil)
    {
        NSArray *array = [[RSSDatabase sharedDatabase] selectAllChannels];
        allChannel = [[NSMutableArray alloc] initWithArray:array];
    }
    return allChannel;
}
-(NSMutableArray *)allArticles
{
    if(allArticles == nil)
    {
        NSArray *array = [[RSSDatabase sharedDatabase] selectAllArticles];
        allArticles = [[NSMutableArray alloc] initWithArray:array];
    }
    return allArticles;
}

-(NSMutableArray *)selectChannelByCategoryId:(int)categoryId
{

    NSMutableArray *array = [[RSSDatabase sharedDatabase] selectChannelByCategoryId:categoryId];
    return array;
}
-(NSMutableArray *)selectChannelByTitle:(NSString *) title
{
    NSMutableArray *array = [[RSSDatabase sharedDatabase] selectChannelByTitle:title];
    
    return array;
}
-(NSMutableArray *)selectArticleByTitle:(NSString *)title
{
    NSMutableArray *array = [[RSSDatabase sharedDatabase] selectArticleByTitle:title];
    return array;
}


-(int)addCategory:(CategoryInfo *)aCategory error:(NSError **)error
{
    NSError *underlyingError;
    int rc=[[RSSDatabase sharedDatabase] addCategory:aCategory error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"新建频道失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit];
        }
        return rc;
    }
    if(allCategory == nil)
    {
        allCategory = [[NSMutableArray alloc] init];
    }
    [allCategory addObject:aCategory];
    return rc;
}
-(int)updateCategory:(CategoryInfo *)aCategory to:(CategoryInfo *)bCategoryo error:(NSError **)error
{
    NSError *underlyingError;
    int rc = [[RSSDatabase sharedDatabase] updateCategory:aCategory to:bCategoryo error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray =[NSArray arrayWithObjects:@"更新频道失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit];
        }
        return rc;
    }
    for (CategoryInfo *category in allCategory)
    {
        if(category._ID == aCategory._ID)
        {
            category._Name = aCategory._Name;
        }
    }
    return rc;
}
-(int)deleteCategory:(CategoryInfo *)aCategory error:(NSError **)error
{
    NSError *underlyingError;
    int rc = [[RSSDatabase sharedDatabase] deleteCategory:aCategory error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"删除频道失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit];
        }
        return rc;
    }
    [allCategory removeObject:aCategory];
    return rc;
}

-(int)addChannel:(ChannelsInfo *)aChannel error:(NSError **)error
{
    NSError *underlyingError;
    int rc=[[RSSDatabase sharedDatabase] addChannel:aChannel error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"新建类别失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit];
        }
        return rc;
    }
    if(allChannel == nil)
    {
        allChannel = [[NSMutableArray alloc] init];
    }
    [allChannel addObject:aChannel];
    return rc;
}
-(int)deleteChannel:(ChannelsInfo *)aChannel error:(NSError **)error
{
    NSError *underlyingError;
    int rc = [[RSSDatabase sharedDatabase] deleteChannel:aChannel error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"删除分类失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit];
        }
        return rc;
    }
    [allChannel removeObject:aChannel];
    return rc;
}

-(int)addArticle:(Articles *)aArticle error:(NSError **)error
{
    NSError *underlyingError;
    int rc=[[RSSDatabase sharedDatabase] addArticle:aArticle error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"新建文章失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit];
        }
        return rc;
    }
    if(allArticles == nil)
    {
        allArticles = [[NSMutableArray alloc] init];
    }
    [allArticles addObject:aArticle];
    return rc;
}
-(int)deleteArticle:(Articles *)aArticle error:(NSError **)error
{
    NSError *underlyingError;
    int rc = [[RSSDatabase sharedDatabase] deleteArticle:aArticle error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"删除文章失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit];
        }
        return rc;
    }
    [allArticles removeObject:aArticle];
    return rc;
}

@end
