//
//  RSSDatabase+CategoryProvider.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-17.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "RSSDatabase+CategoryProvider.h"
#import "CategoryInfo.h"

@implementation RSSDatabase (CategoryProvider)

-(NSArray *)selectAllCategories{
    NSString *sql=@"SELECT Id,Name,OrderIndex FROM Categories ORDER BY OrderIndex";
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
    
    NSMutableArray *items=[NSMutableArray arrayWithCapacity:16];
    if (dr!=nil){
        while ([dr read]) {
            CategoryInfo *item=[[CategoryInfo alloc] init];
            item.ID=[dr integerValueForColumnIndex:0];
            item.name=[dr stringValueForColumnIndex:1];
            item.orderIndex=[dr integerValueForColumnIndex:2];
            [items addObject:item];
            [item release];
        }
        [dr close];
    }
    
    [sqliteDatabase close];
    return items;
}

- (CategoryInfo *)selectCategoryById:(int)oid{
    NSString *sql=[NSString stringWithFormat:@"SELECT Id,Name,OrderIndex FROM Categories WHERE Id=%i",oid];
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
    
    CategoryInfo *item=nil;
    if (dr!=nil){
        if ([dr read]) {
            item=[[[CategoryInfo alloc] init] autorelease];
            item.ID=[dr integerValueForColumnIndex:0];
            item.name=[dr stringValueForColumnIndex:1];
            item.orderIndex=[dr integerValueForColumnIndex:2];
        }
        [dr close];
    }
    
    [sqliteDatabase close];
    return item;
}

- (CategoryInfo *)selectCategoryByName:(NSString *)name{
    NSString *sql=[NSString stringWithFormat:@"SELECT Id,Name,OrderIndex FROM Categories WHERE Name='%@'",name];
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
    
    CategoryInfo *item=nil;
    if (dr!=nil){
        if ([dr read]) {
            item=[[[CategoryInfo alloc] init] autorelease];
            item.ID=[dr integerValueForColumnIndex:0];
            item.name=[dr stringValueForColumnIndex:1];
            item.orderIndex=[dr integerValueForColumnIndex:2];
        }
        [dr close];
    }
    
    [sqliteDatabase close];
    return item;
}

- (int)selectMaxCategoryOrderIndex{
    NSString *sql=[NSString stringWithFormat:@"SELECT Max(OrderIndex) FROM Categories"];
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
    
    int index;
    if (dr!=nil){
        if ([dr read]) {
            index=[dr integerValueForColumnIndex:0];            
        }
        [dr close];
    }
    
    [sqliteDatabase close];
    return index;
}

- (int)insertCategory:(CategoryInfo *)category error:(NSError **)error{
    NSString *sql=[NSString stringWithFormat:@"INSERT INTO Categories(Name,OrderIndex) VALUES('%@',%i)",category.name,category.orderIndex];
    int lastRowId;    
    int rc=[sqliteDatabase executeNonQuery:sql outputLastInsertRowId:&lastRowId error:error];
    if (rc==SQLITE_OK) {
        category.ID=lastRowId;
    }    
    return rc;
}

- (int)updateCategory:(CategoryInfo *)category error:(NSError **)error{
    NSString *sql=[NSString stringWithFormat:@"UPDATE Categories SET Name='%@',OrderIndex=%i WHERE Id=%i",category.name,category.orderIndex,category.ID];
    int rc=[sqliteDatabase executeNonQuery:sql error:error];    
    return rc;
}

- (int)deleteCategory:(CategoryInfo *)category error:(NSError **)error{
    NSString *sql=[NSString stringWithFormat:@"DELETE FROM Categories WHERE Id=%i",category.ID];
    int rc=[sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}

@end
