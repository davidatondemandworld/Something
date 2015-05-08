//
//  LoginManager.h
//  TCPListner
//
//  Created by 深圳鲲鹏 on 13-9-29.
//
//

#import <Foundation/Foundation.h>
#define BUSINESS_ERROR_DOMAIN @"BUSINESS_ERROR_DOMAIN"
@class Login;
@interface LoginManager : NSObject
{
    NSMutableArray *allLogin;
}
+(LoginManager *)defaultManager;
-(int) addLogin:(Login *) aLogin error:(NSError **)error;
-(int) deleteLogin:(Login *)aLogin error:(NSError **)error;
-(int) updateLogin:(Login *)aLogin to:(Login *)bLogin error:(NSError **)error;

-(NSMutableArray *)selectAllLogin;

-(Login *)selectLoginByName:(NSString *) name;
@end
