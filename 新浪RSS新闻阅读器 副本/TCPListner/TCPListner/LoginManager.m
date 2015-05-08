//
//  LoginManager.m
//  TCPListner
//
//  Created by 深圳鲲鹏 on 13-9-29.
//
//

#import "LoginManager.h"
#import "Database.h"
#import "Login.h"
static LoginManager *staticLoginManager;

@implementation LoginManager
+(LoginManager *)defaultManager
{
    if(staticLoginManager == nil)
    {
        staticLoginManager = [[LoginManager alloc] init];
    }
    return staticLoginManager;
}

-(int) addLogin:(Login *) aLogin error:(NSError **)error
{
    NSError *underlyingError;
    int rc=[[Database sharedDatabase] addLogin:aLogin error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"新建用户失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit];
        }
        return rc;
    }
    if(allLogin == nil)
    {
        allLogin = [[NSMutableArray alloc] init];
    }
    [allLogin addObject:aLogin];
    return rc;
}
-(int) deleteLogin:(Login *)aLogin error:(NSError **)error
{
    NSError *underlyingError;
    int rc = [[Database sharedDatabase] deleteLogin:aLogin error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray = [NSArray arrayWithObjects:@"删除用户失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit];
        }
        return rc;
    }
    [allLogin removeObject:aLogin];
    return rc;
}
-(int) updateLogin:(Login *)aLogin to:(Login *)bLogin error:(NSError **)error
{
    NSError *underlyingError;
    int rc = [[Database sharedDatabase] updateLogin:aLogin to:bLogin error:&underlyingError];
    if(rc)
    {
        if(error!=NULL)
        {
            NSArray *objArray =[NSArray arrayWithObjects:@"更新用户失败",underlyingError, nil];
            NSArray *keyArray = [NSArray arrayWithObjects:NSLocalizedDescriptionKey,NSUnderlyingErrorKey, nil];
            NSDictionary *eDit = [NSDictionary dictionaryWithObjects:objArray forKeys:keyArray];
            *error = [[NSError alloc] initWithDomain:BUSINESS_ERROR_DOMAIN code:rc userInfo:eDit];
        }
        return rc;
    }
    for (Login *login in allLogin)
    {
        if(login._ID == aLogin._ID)
        {
            login._name = aLogin._name;
            login._psw = aLogin._psw;
        }
    }
    return rc;

}

-(NSMutableArray *)selectAllLogin
{
    if(allLogin == nil)
    {
        NSArray *array = [[Database sharedDatabase] selectAllLogin];
        allLogin = [[NSMutableArray alloc] initWithArray:array];
    }
    return allLogin;
}
-(Login *)selectLoginByName:(NSString *) name
{
    Login *login = [[Database sharedDatabase] selectLoginByName:name];
    return login;
}
@end
