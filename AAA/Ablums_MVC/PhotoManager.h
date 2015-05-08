
#import <Foundation/Foundation.h>
#define BUSINESS_ERROR_DOMAIN @"BUSINESS_ERROR_DOMAIN"
@class PhotoInfo;
@class CategoryInfo;

@interface PhotoManager : NSObject
{
    NSMutableArray *allPhoto;
    NSMutableArray *allCategory;
}
+(PhotoManager *)defaultManager;
-(NSArray *)allPhotos;
-(NSMutableArray *)allCategory;
-(int)addPhoto:(PhotoInfo *) aPhoto error:(NSError **)error;
-(int)updatePhoto:(PhotoInfo *)aPhoto to:(PhotoInfo *)bPhoto error:(NSError **)error;
-(int)deletePhoto:(PhotoInfo *)aPhoto error:(NSError **)error;
-(int)removePhoto:(PhotoInfo *)aPhoto error:(NSError **)error;

-(int)addCategory:(CategoryInfo *)aCategory error:(NSError **)error;
-(int)deleteCategory:(CategoryInfo *)aCategory error:(NSError **)error;

@end
