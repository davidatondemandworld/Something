//
//  CategoryManager.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-17.
//
//

#import <Foundation/Foundation.h>
@class CategoryInfo;
@class RSSDatabase;

@interface CategoryManager : NSObject{
    NSMutableArray *_items;
    RSSDatabase *db;    
}

+(CategoryManager *) defaultManager;

- (NSArray *) allCategories;
- (CategoryInfo *) categoryById:(int) categoryId;
- (int) saveCategory:(CategoryInfo *) category old:(CategoryInfo *) old  error:(NSError **)error;
- (int) deleteCategory:(CategoryInfo *) category error:(NSError **)error;
- (void)dispose;

@end
