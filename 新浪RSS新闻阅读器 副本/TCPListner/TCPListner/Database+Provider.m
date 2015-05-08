//
//  Database+Provider.m
//  TCPListner
//
//  Created by 深圳鲲鹏 on 13-9-29.
//
//

#import "Database.h"
#import "Login.h"

@implementation Database (Provider)
-(int) addLogin:(Login *) aLogin error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"insert into Login(Name,Password)values('%@','%@');",aLogin._name,aLogin._psw];
    int lastRowId;
    int rc = [sqliteDatabase executeNonQuery:sql outputLastInsertRowId:&lastRowId error:error];
    if(rc == SQLITE_OK)
    {
        aLogin._ID = lastRowId;
    }
    
    return rc;
}
-(int) deleteLogin:(Login *)aLogin error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"delete from Login where Name='%@'",aLogin._name];
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}
-(int) updateLogin:(Login *)aLogin to:(Login *)bLogin error:(NSError **)error
{
    NSString *sql = [NSString stringWithFormat:@"update Login set (Name,Password)values('%@','%@') where Id=%i;",bLogin._name,bLogin._psw,aLogin._ID];
    
    int rc = [sqliteDatabase executeNonQuery:sql error:error];
    return rc;
}
-(NSMutableArray *)selectAllLogin
{
    NSString *sql = @"select *from Login";
    [sqliteDatabase open];
    SqliteDataReader *dr = [sqliteDatabase executeQuery:sql];
    NSMutableArray *array=[NSMutableArray array];
    if (dr!=nil){
        while ([dr read]) {
            Login *login=[[Login alloc] init];
            login._ID = [dr integerValueForColumnIndex:0];
            login._name=[dr stringValueForColumnIndex:1];
            login._psw = [dr stringValueForColumnIndex:2];
            [array addObject:login];
        }
        [dr close];
    }
    [sqliteDatabase close];
    
    return array;
}
-(Login *)selectLoginByName:(NSString *) name
{
    Login *alogin=nil;
    
    NSString *sql=[NSString stringWithFormat:@"SELECT * FROM Login WHERE Name = '%@';",name];
    [sqliteDatabase open];
    SqliteDataReader *dr= [sqliteDatabase executeQuery:sql];
        
    if (dr!=nil) {
        while ([dr read]) {
            alogin=[[Login alloc] init];
            alogin._ID = [dr integerValueForColumnIndex:0];
            alogin._name = [dr stringValueForColumnIndex:1];
            alogin._psw = [dr stringValueForColumnIndex:2];
        }
        [dr close];
    }
    [sqliteDatabase close];
    
    return alogin;
}
@end
