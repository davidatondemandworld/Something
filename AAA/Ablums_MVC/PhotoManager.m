

#import "PhotoManager.h"
#import "PhotoDatabase.h"
#import "PhotoInfo.h"
#import "CategoryInfo.h"

static PhotoManager *staticPhotoManager;

@implementation PhotoManager
+(PhotoManager *)defaultManager
{
    if(staticPhotoManager == nil)
    {
        staticPhotoManager = [[PhotoManager alloc] init];
    }
    return staticPhotoManager;
}
-(NSArray *)allPhotos
{
    if(allPhoto == nil)
    {
        NSArray *array = [[PhotoDatabase sharedDatabase] selectAllPhotos];
        allPhoto = [[NSMutableArray alloc] initWithArray:array];
    }
    return allPhoto;
}
-(NSMutableArray *)allCategory
{
    if(allCategory == nil)
    {
        NSArray *array = [[PhotoDatabase sharedDatabase] selectAllCategory];
        allCategory = [[NSMutableArray alloc] initWithArray:array];
    }
    return allCategory;
}

-(int)addPhoto:(PhotoInfo *)aPhoto error:(NSError **)error
{
    NSError *underlyingError;
    int rc=[[PhotoDatabase sharedDatabase] addPhoto:aPhoto error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"新建相册失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit] autorelease];
        }
        return rc;
    }
    if(allPhoto == nil)
    {
        allPhoto = [[NSMutableArray alloc] init];
    }
    [allPhoto addObject:aPhoto];
    return rc;
}
-(int)updatePhoto:(PhotoInfo *)aPhoto to:(PhotoInfo *)bPhoto error:(NSError **)error
{
    NSError *underlyingError;
    int rc = [[PhotoDatabase sharedDatabase] updatePhoto:aPhoto to:bPhoto error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray =[NSArray arrayWithObjects:@"更新相册失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit] autorelease];
        }
        return rc;
    }
    for (PhotoInfo *photo in allPhoto)
    {
        if(photo.photoId == aPhoto.photoId)
        {
            photo.name = aPhoto.name;
            photo.categoryId = aPhoto.categoryId;
        }
    }
    return rc;
}
-(int)deletePhoto:(PhotoInfo *)aPhoto error:(NSError **)error
{
    NSError *underlyingError;
    int rc = [[PhotoDatabase sharedDatabase] deletePhoto:aPhoto error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"删除照片失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit] autorelease];
        }
        return rc;
    }
    [allPhoto removeObject:aPhoto];
    return rc;
}
-(int)removePhoto:(PhotoInfo *)aPhoto error:(NSError **)error
{
    NSError *underlyingError;
    int rc = [[PhotoDatabase sharedDatabase] removePhoto:aPhoto error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"移除照片失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit] autorelease];
        }
        return rc;
    }
    [allPhoto removeObject:aPhoto];
    return rc;
}

-(int)addCategory:(CategoryInfo *)aCategory error:(NSError **)error
{
    NSError *underlyingError;
    int rc=[[PhotoDatabase sharedDatabase] addCategory:aCategory error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"新建相册失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit] autorelease];
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
-(int)deleteCategory:(CategoryInfo *)aCategory error:(NSError **)error
{
    NSError *underlyingError;
    int rc = [[PhotoDatabase sharedDatabase] deleteCategory:aCategory error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"删除分类失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit] autorelease];
        }
        return rc;
    }
    [allCategory removeObject:aCategory];
    return rc;
}

@end
