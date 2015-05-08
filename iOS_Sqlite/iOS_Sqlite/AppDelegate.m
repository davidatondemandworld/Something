//
//  AppDelegate.m
//  iOS_Sqlite
//
//  Created by Andy Tung on 13-8-29.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "ProductInfo.h"

#import <sqlite3.h>

@interface AppDelegate (){
    NSString *_filename;
}
- (void) executeSql:(NSString *) sql;
- (NSArray *) executeQuery:(NSString *) sql;
@end

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (void)executeSql:(NSString *)strSql{
    sqlite3 *db;
    char *zErr;
    int rc;
    const char *sql;
    rc = sqlite3_open([_filename UTF8String], &db);
    if (rc) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        exit(1);
    }
    sql = [strSql UTF8String];
    rc = sqlite3_exec(db, sql, NULL, NULL, &zErr);
    if (rc != SQLITE_OK) { if (zErr != NULL) {
        fprintf(stderr, "SQL error: %s\n", zErr);
        sqlite3_free(zErr); }
    }
    
    sqlite3_close(db);
}

- (NSArray *)executeQuery:(NSString *)strSql{
    int rc, i, ncols;
    sqlite3 *db;
    sqlite3_stmt *stmt;
    const char *sql;
    const char *tail;
    rc = sqlite3_open([_filename UTF8String], &db);
    if(rc) {
        fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db)); sqlite3_close(db);
        exit(1);
    }
    sql = [strSql UTF8String];
    //rc = sqlite3_prepare(db, sql, (int)strlen(sql), &stmt, &tail)
    rc = sqlite3_prepare(db, sql, -1, &stmt, NULL);
    if(rc != SQLITE_OK) {
        fprintf(stderr, "SQL error: %s\n", sqlite3_errmsg(db));
    }
    
    rc = sqlite3_step(stmt);
    ncols = sqlite3_column_count(stmt);
    NSMutableArray *array=[NSMutableArray arrayWithCapacity:16];
    while(rc == SQLITE_ROW) {
        for(i=0; i < ncols; i++) {
            fprintf(stderr, "'%s' ", sqlite3_column_text(stmt, i));            
        }
        fprintf(stderr, "\n");
        ProductInfo *product=[[[ProductInfo alloc] init] autorelease];
        product.ID=sqlite3_column_int(stmt, 0);
        product.name=[NSString stringWithCString:(const char *)sqlite3_column_text(stmt, 2) encoding:NSUTF8StringEncoding];
        product.price=sqlite3_column_double(stmt, 1);
        [array addObject:product];        
        
        rc = sqlite3_step(stmt);
    }
    sqlite3_finalize(stmt);
    sqlite3_close(db);
    return array;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    _filename = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/test.sqlite"];
    
    //NSString *sql=@"CREATE TABLE Product(ID integer PRIMARY KEY AUTOINCREMENT,Name text,Price real)";
    //NSString *sql=@"INSERT INTO Product(Name,Price)VALUES('iPhone4s',3888);INSERT INTO Product(Name,Price)VALUES('iPhone5',4888);INSERT INTO Product(Name,Price)VALUES('iPad',2888);";
    
    NSString *sql=@"SELECT ID,Price,Name FROM Product";
    NSArray *array = [self executeQuery:sql];
    NSLog(@"%@",array);
    
    //[self executeSql:sql];
    NSLog(@"ok");
    
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
