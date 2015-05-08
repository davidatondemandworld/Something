//
//  AppDelegate.m
//  iOS_Html
//
//  Created by Andy Tung on 13-9-13.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "TFHpple.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    NSString *surl=@"http://www.baidu.com/";
    NSURL *url=[NSURL URLWithString:surl];
    NSURLRequest *req=[NSURLRequest requestWithURL:url];

    //NSData *data=[NSURLConnection sendSynchronousRequest:req returningResponse:nil error:nil];
    /*
    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue currentQueue] completionHandler:^
     (NSURLResponse *response, NSData *data, NSError *error) {
        TFHpple *hpple=[TFHpple hppleWithHTMLData:data];
        NSArray *array=[hpple searchWithXPathQuery:@"/html/head/title"];
        TFHppleElement *element=[array objectAtIndex:0];
        NSArray *array2=element.children;
        TFHppleElement *element2=[array2 objectAtIndex:0];
        
        NSLog(@"tagName:%@",element.tagName);
        NSLog(@"tagName:%@,content:%@",element2.tagName,element2.content);
    }];
     */
    
     _connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    NSLog(@"Send Async request");
   
    /*
    TFHpple *hpple=[TFHpple hppleWithHTMLData:data];
    NSArray *array=[hpple searchWithXPathQuery:@"/html/head/title"];
    TFHppleElement *element=[array objectAtIndex:0];
    NSArray *array2=element.children;
    TFHppleElement *element2=[array2 objectAtIndex:0];
    
    NSLog(@"tagName:%@",element.tagName);
    //NSLog(@"tagName:%@,content:%@",element2.tagName,element2.content);
     */
    
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

#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
    NSLog(@"didReceiveResponse");
    NSLog(@"%i",httpResponse.statusCode);
    NSLog(@"Content-Length:%lli",httpResponse.expectedContentLength);
    NSLog(@"Content-Length:%@",[[httpResponse allHeaderFields] objectForKey:@"Content-Length"]);
    NSLog(@"%@",httpResponse.allHeaderFields);
    _data=[[NSMutableData alloc] initWithCapacity:10000];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    NSLog(@"didReceiveData:%i",[data length]);
    [_data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"%i",[_data length]);
    
     TFHpple *hpple=[TFHpple hppleWithHTMLData:_data];
     NSArray *array=[hpple searchWithXPathQuery:@"/html/head/title"];
     TFHppleElement *element=[array objectAtIndex:0];
     NSArray *array2=element.children;
     TFHppleElement *element2=[array2 objectAtIndex:0];

     NSLog(@"tagName:%@",element.tagName);
     NSLog(@"tagName:%@,content:%@",element2.tagName,element2.content); 

}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    
}

@end















