//
//  CategoryManager.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-17.
//
//

#import "CategoryManager.h"
#import "Utilities.h"
#import "CategoryInfo.h"
#import "RSSDatabase+CategoryProvider.h"

#define CATEGORYMANAGER_ERROR_DOMAIN @"CATEGORYMANAGER_ERROR_DOMAIN"
#define CATEGORYMANAGER_ERROR_DUPLICATED_NAME 1001
#define CATEGORYMANAGER_ERROR_DUPLICATED_NAME_MSG @"已存在同名类目"

static CategoryManager *staticInstance=nil;

@implementation CategoryManager

- (id)init{
    if (self=[super init]) {
        db=[RSSDatabase sharedDatabase];
        NSArray *items=[db selectAllCategories];
        if (items==nil) {
            _items=[[NSMutableArray alloc] initWithCapacity:8];
        }
        else{
            _items=[[NSMutableArray alloc] initWithArray:items];
        }        
    }
    return self;
}

- (void)dealloc{
    [_items release];
    [super dealloc];
}

+(id)defaultManager{
    if (staticInstance==nil) {
        staticInstance=[[[self class] alloc] init];
    }
    return staticInstance;
}

- (NSArray *)allCategories{    
    return _items;
}

- (CategoryInfo *) categoryById:(int)categoryId{
    for (CategoryInfo *item in _items) {
        if (item.ID==categoryId) {
            return item;
        }
    }
    return nil;
}

-(int)saveCategory:(CategoryInfo *)category old:(CategoryInfo *)old error:(NSError **)error{
    int rc;
    CategoryInfo *item=[db selectCategoryByName:category.name];
    if (old!=nil) {
        if (item!=nil&&item.ID!=category.ID) {
            if (error!=nil) {
                *error=[NSError errorWithDomain:CATEGORYMANAGER_ERROR_DOMAIN  code:CATEGORYMANAGER_ERROR_DUPLICATED_NAME errmsg:CATEGORYMANAGER_ERROR_DUPLICATED_NAME_MSG innerError:nil];
            }
            return CATEGORYMANAGER_ERROR_DUPLICATED_NAME;
        }
        rc=[db updateCategory:category error:error];
        if (rc==0) {
            old.name=category.name;
        }
    }
    else{
        if (item!=nil) {
            if (error!=nil) {
                *error=[NSError errorWithDomain:CATEGORYMANAGER_ERROR_DOMAIN  code:CATEGORYMANAGER_ERROR_DUPLICATED_NAME errmsg:CATEGORYMANAGER_ERROR_DUPLICATED_NAME_MSG innerError:nil];
            }
            return CATEGORYMANAGER_ERROR_DUPLICATED_NAME;
        }
        
        int orderIndex=[[RSSDatabase sharedDatabase] selectMaxCategoryOrderIndex]+1;
        category.orderIndex=orderIndex;
        
        rc=[[RSSDatabase sharedDatabase] insertCategory:category error:error];
        if (rc==0) {
            [_items addObject:category];
        }        
    }
    return rc;
}

- (int)deleteCategory:(CategoryInfo *)category error:(NSError **)error{
    int rc=[db deleteCategory:category error:error];
    if (rc==0) {
        [_items removeObject:category];
    }
    return rc;
}

- (void)dispose{
    if (staticInstance!=nil) {
        [staticInstance release];
        staticInstance=nil;
    }
}

@end
