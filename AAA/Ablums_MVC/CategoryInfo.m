

#import "CategoryInfo.h"

@implementation CategoryInfo
@synthesize Category,myId;
-(NSString *)description
{
    return [NSString stringWithFormat:@"Id:%i,CategoryId;%@",myId,Category];
}
-(void)dealloc
{
    [Category release];
    [super dealloc];
}
@end
