//
//  AppDelegate.m
//  TaoBaoApi
//
//  Created by  on 12-8-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "TOPHelper.h"
#import "JSON.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *requestParams=[NSDictionary dictionaryWithObjectsAndKeys:@"taobao.itemcats.get",@"method",@"json",@"format",@"cid,parent_cid,name,is_parent",@"fields",@"0",@"parent_cid", nil];
    NSData *data= [TOPHelper sendSynchronousRequest:requestParams];
    
    NSDictionary *obj=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *array=[[[obj objectForKey:@"itemcats_get_response"] objectForKey:@"item_cats"] objectForKey:@"item_cat"];
    
    for (NSDictionary *cat in array) {
        NSLog(@"id=%@,name=%@",[cat objectForKey:@"cid"],[cat objectForKey:@"name"]);
    }
    
        
    
//    NSString *str=[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    //NSLog(@"%@",str);
//    
//    NSDictionary *obj=[str JSONValue];
//    NSLog(@"%@",obj);
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
