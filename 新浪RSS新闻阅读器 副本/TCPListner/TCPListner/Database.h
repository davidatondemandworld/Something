//
//  Database.h
//  TCPListner
//
//  Created by 深圳鲲鹏 on 13-9-29.
//
//

#import <Foundation/Foundation.h>
#import "SqliteDatabase.h"
@class Login;
@interface Database : NSObject
{
    SqliteDatabase *sqliteDatabase;
}
+(void) createDatabaseIfNotExists;
+(NSString *) filename;
+(Database *) sharedDatabase;

@end
@interface Database (Provider)
-(int) addLogin:(Login *) aLogin error:(NSError **)error;
-(int) deleteLogin:(Login *)aLogin error:(NSError **)error;
-(int) updateLogin:(Login *)aLogin to:(Login *)bLogin error:(NSError **)error;

-(NSMutableArray *)selectAllLogin;

-(Login *)selectLoginByName:(NSString *) name;

@end