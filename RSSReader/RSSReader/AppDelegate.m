//
//  AppDelegate.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-14.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
//Subscribtions
#import "CategoryListController.h"
#import "SubscribeEditController.h"
//Channels
#import "ChannelSourceListController.h"
#import "ChannelCategoryListController.h"
#import "ChannelListController.h"
#import "ArticleListController.h"
#import "ArticleDetailController.h"
//Favorites
#import "FavoriteListController.h"
//Settings
#import "SettingsController.h"
//Database
#import "RSSDatabase.h"

#import "SinaChannelParser.h"
#import "RSSChannelParser.h"
#import "RSSFormatAnalyzer.h"
#import "Channel.h"


@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    NSLog(@"%@",NSHomeDirectory());
    
    // Override point for customization after application launch.
    
    /* 
     * TestChannel    
    Channel *channel=[[[Channel alloc] init] autorelease];
    channel.url=@"http://rss.sina.com.cn/news/marquee/ddt.xml";
    NSArray *items= [channel loadItems:nil];
    NSLog(@"%@",items);
    NSLog(@"%@",channel);
     */
   
    /* 
     * TestRssFormatAnalyzer     
     NSString *strurl=@"http://rss.sina.com.cn/news/marquee/ddt.xml";
     NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:strurl]];
     NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
     id analyzer=[[[RSSFormatAnalyzer alloc] init] autorelease];
    RSSFormat format=[analyzer analyze:data];
     NSLog(@"%i",format);
     */
    
    /* 
     * TestRssChannelParser 
     
    NSString *strurl=@"http://rss.sina.com.cn/news/marquee/ddt.xml";
    NSURLRequest *request=[NSURLRequest requestWithURL:[NSURL URLWithString:strurl]];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    id<ChannelParsing> parser=[[[RSSChannelParser alloc] init] autorelease];
    NSDictionary *dict=[parser parseData:data error:nil];
    NSLog(@"%@",dict);
     */
    
    /*
     * Test SinaChannelParser
     
    NSString *strurl=@"http://rss.sina.com.cn/sina_all_opml.xml";
    NSURL *url=[NSURL URLWithString:strurl];
    id<ChannelSourceParsing> parser=[[SinaChannelParser alloc] init];
    NSDictionary *dict = [parser parseURL:url error:nil];
    NSLog(@"%@",dict);
     */
    
    
    [RSSDatabase createDatabaseIfNotExists];
    
    UIViewController *categoryList=[[[CategoryListController alloc] initWithStyle:(UITableViewStylePlain)] autorelease];
    UINavigationController *nav0=[[[UINavigationController alloc] initWithRootViewController:categoryList] autorelease];    
    UITabBarItem *item0=[[UITabBarItem alloc] initWithTitle:@"订阅" image:[UIImage imageNamed:@"rss-30x30.png"] tag:100];
    nav0.tabBarItem=item0;
    
    UIViewController *channelSourceList=[[[ChannelSourceListController alloc] initWithStyle:(UITableViewStylePlain)] autorelease];
    UINavigationController *nav1=[[[UINavigationController alloc] initWithRootViewController:channelSourceList] autorelease];
    
    UITabBarItem *item1=[[[UITabBarItem alloc] initWithTabBarSystemItem:(UITabBarSystemItemDownloads) tag:101] autorelease];
    [item1 setTitle:@"频道"];
    nav1.tabBarItem=item1;
    
    UIViewController *favoriteList=[[[FavoriteListController alloc] initWithStyle:(UITableViewStyleGrouped)] autorelease];
    UINavigationController *nav2=[[[UINavigationController alloc] initWithRootViewController:favoriteList] autorelease];
    UITabBarItem *item2=[[[UITabBarItem alloc] initWithTabBarSystemItem:(UITabBarSystemItemFavorites) tag:102] autorelease];
    [item2 setTitle:@"收藏"];
    nav2.tabBarItem=item2;
    
    
    UIViewController *settings=[[[SettingsController alloc] init] autorelease];
    UINavigationController *nav3=[[[UINavigationController alloc] initWithRootViewController:settings] autorelease];
    UITabBarItem *item3=[[[UITabBarItem alloc] initWithTitle:@"设置" image:[UIImage imageNamed:@"settings-30x30.png"] tag:103] autorelease];    
    nav3.tabBarItem=item3;
    
    NSArray *tabItems=[NSArray arrayWithObjects:nav0,nav1,nav2,nav3, nil];
    
    UITabBarController *viewController=[[[UITabBarController alloc] init] autorelease];
    [viewController setViewControllers:tabItems];    
    
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController=viewController;
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
