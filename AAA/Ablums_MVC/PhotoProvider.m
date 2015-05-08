

#import "PhotoDatabase.h"
#import "PhotoInfo.h"
#import "CategoryInfo.h"

@implementation PhotoDatabase(PhotoProvider)
-(int)addPhoto:(PhotoInfo *)aPhoto error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"insert into Photos(Name,CategoryId)values('%@',%d);",aPhoto.name,aPhoto.categoryId];
    int lastRowId;
    int rc = [sqliteDatabase executeNonQuery:sql outputLastInsertRowId:&lastRowId error:error];
    if(rc == SQLITE_OK)
    {
        aPhoto.photoId = lastRowId;
    }
    return rc;
}
-(int)updatePhoto:(PhotoInfo *)aPhoto to:(PhotoInfo *)bPhoto error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"update Photos set Name='%@',CategoryId=%d where Id=%i;",bPhoto.name,bPhoto.categoryId,aPhoto.photoId];
    
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}
-(int)deletePhoto:(PhotoInfo *)aPhoto error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"delete from Photos where Name='%@'",aPhoto.name];
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}
-(int)removePhoto:(PhotoInfo *)aPhoto error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"delete from Photos where Name='%@' and CategoryId=%d;",aPhoto.name,aPhoto.categoryId];
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}

-(int)addCategory:(CategoryInfo *)aCategory error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"insert into Category(Category)values('%@');",aCategory.Category];
    int lastRowId;
    int rc = [sqliteDatabase executeNonQuery:sql outputLastInsertRowId:&lastRowId error:error];
    if(rc == SQLITE_OK)
    {
        aCategory.myId = lastRowId;
    }
    return rc;
}
-(int)updateCategory:(CategoryInfo *)aCategory error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"update Category set Category='%@' where Id=%i",aCategory.Category,aCategory.myId];
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}
-(int)deleteCategory:(CategoryInfo *)aCategory error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"delete from Category where Category='%@'",aCategory.Category];
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}

-(NSMutableArray *)selectPhotoByCategoryId:(int) categoryId
{
    NSString *sql = [NSString stringWithFormat:@"select * from Photos where categoryId=%i",categoryId];
        
    [sqliteDatabase open];
    SqliteDataReader *dr = [sqliteDatabase executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (dr!=nil){
        while ([dr read])
        {
            PhotoInfo *photo=[[PhotoInfo alloc] init];
            photo.photoId = [dr integerValueForColumnIndex:0];
            photo.name=[dr stringValueForColumnIndex:1];
            photo.categoryId = [dr integerValueForColumnIndex:2];

            [array addObject:photo];
            [photo release];
        }
        [dr close];
    }
    [sqliteDatabase close];
    return array;
}
-(NSMutableArray *)selectPhotoByPhotoName:(NSString *)PhotoName
{
    NSString *sql = [NSString stringWithFormat:@"select Name,categoryId from Photos where Name='%@'",PhotoName];
    [sqliteDatabase open];
    SqliteDataReader *dr = [sqliteDatabase executeQuery:sql];
    NSMutableArray *array = [[NSMutableArray alloc] init];
    if (dr!=nil){
        while ([dr read])
        {
            PhotoInfo *photo=[[PhotoInfo alloc] init];
            photo.name=[dr stringValueForColumnIndex:0];
            photo.categoryId = [dr integerValueForColumnIndex:1];
            [array addObject:photo];
            [photo release];
        }
        [dr close];
    }
    [sqliteDatabase close];
    return array;
}
-(int)selectCategoryIdByCategory:(NSString *)category
{
    NSString *sql = [NSString stringWithFormat:@"select Id from category where category='%@';",category];
    [sqliteDatabase open];
    SqliteDataReader *dr = [sqliteDatabase executeQuery:sql];
    int categoryId;
    if(dr!=nil)
    {
        while([dr read])
        {
            CategoryInfo *category = [[CategoryInfo alloc] init];
            category.myId = [dr integerValueForColumnIndex:0];
            categoryId = category.myId;
            [category release];
        }
        [dr close];
    }
    [sqliteDatabase close];
    return categoryId;
}
-(NSArray *)selectAllPhotos
{
    NSString *sql = @"select Id,Name,CategoryId from Photos";
    [sqliteDatabase open];
    SqliteDataReader *dr = [sqliteDatabase executeQuery:sql];
    NSMutableArray *array=[NSMutableArray array];
    if (dr!=nil){
        while ([dr read]) {
            PhotoInfo *photo=[[PhotoInfo alloc] init];
            photo.photoId=[dr integerValueForColumnIndex:0];
            photo.name=[dr stringValueForColumnIndex:1];
            photo.categoryId=[dr integerValueForColumnIndex:2];
            [array addObject:photo];
            [photo release];
        }
        [dr close];
    }
    [sqliteDatabase close];
    
    return array;
}
-(NSArray *)selectAllCategory
{
    NSString *sql = @"select Id,Category from Category";
    [sqliteDatabase open];
    SqliteDataReader *dr = [sqliteDatabase executeQuery:sql];
    NSMutableArray *array=[NSMutableArray array];
    if (dr!=nil){
        while ([dr read]) {
            CategoryInfo *category=[[CategoryInfo alloc] init];
            category.myId = [dr integerValueForColumnIndex:0];
            category.Category=[dr stringValueForColumnIndex:1];
            [array addObject:category];
            [category release];
        }
        [dr close];
    }
    [sqliteDatabase close];
    
    return array;
}

@end
