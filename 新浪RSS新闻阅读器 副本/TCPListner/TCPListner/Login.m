//
//  Login.m
//  TCPListner
//
//  Created by 深圳鲲鹏 on 13-9-29.
//
//

#import "Login.h"

@implementation Login
@synthesize _ID,_name,_psw;
-(NSString *)description
{
    return [NSString stringWithFormat:@"ID:%i, Name:%@, Psw:%@",_ID,_name,_psw];
}
@end
