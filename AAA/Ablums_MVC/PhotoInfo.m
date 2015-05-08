
#import "PhotoInfo.h"

@implementation PhotoInfo
@synthesize photoId,name,categoryId;

-(NSString *)description
{
    return [NSString stringWithFormat:@"Id:%i,Name:%@,CategoryId:%i",photoId,name,categoryId];
}
-(void)dealloc
{
    [name release];
    [super dealloc];
}

@end
