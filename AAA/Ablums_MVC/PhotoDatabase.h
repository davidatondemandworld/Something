//
//  PhotoDatabase.h
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-3.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SqliteDatabase.h"
@class PhotoInfo;
@class CategoryInfo;

@interface PhotoDatabase : NSObject
{
    SqliteDatabase *sqliteDatabase;
}
+(void) createDatabaseIfNotExists;
+(NSString *) filename;
+(PhotoDatabase *) sharedDatabase;
@end

@interface PhotoDatabase (PhotoProvider)
-(int) addPhoto:(PhotoInfo *) aPhoto error:(NSError **)error;
-(int) updatePhoto:(PhotoInfo *)aPhoto to:(PhotoInfo *)bPhoto error:(NSError **)error;
-(int) deletePhoto:(PhotoInfo *)aPhoto error:(NSError **)error;
-(int) removePhoto:(PhotoInfo *)aPhoto error:(NSError **)error;

-(int) addCategory:(CategoryInfo *) aCategory error:(NSError **)error;
-(int) updateCategory:(CategoryInfo *)aCategory error:(NSError **)error;
-(int) deleteCategory:(CategoryInfo *)aCategory error:(NSError **)error;


-(NSMutableArray *)selectPhotoByCategoryId:(int) categoryId;
-(NSMutableArray *)selectPhotoByPhotoName:(NSString *)PhotoName;
-(int)selectCategoryIdByCategory:(NSString *)category;
-(NSArray *)selectAllPhotos;
-(NSArray *)selectAllCategory;
@end
