//
//  RSSDatabase+CategoryProvider.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-17.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RSSDatabase.h"
@class CategoryInfo;

@interface RSSDatabase (CategoryProvider)

-(NSArray *) selectAllCategories;
-(CategoryInfo *)selectCategoryById:(int)oid;
-(CategoryInfo *)selectCategoryByName:(NSString *)name;
-(int) selectMaxCategoryOrderIndex;

-(int) insertCategory:(CategoryInfo *)category error:(NSError **)error;
-(int) updateCategory:(CategoryInfo *)category error:(NSError **)error;
-(int) deleteCategory:(CategoryInfo *)category error:(NSError **)error;

@end
