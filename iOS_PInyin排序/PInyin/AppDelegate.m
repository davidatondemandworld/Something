//
//  AppDelegate.m
//  PInyin
//
//  Created by bourbon on 14-1-8.
//  Copyright (c) 2014年 bourbon. All rights reserved.
//

#import "AppDelegate.h"
#import "ChineseString.h"
#import "pinyin.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, CFSTR("重庆"));
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    NSLog(@"%@", string);

    
    //Step1:初始化
    NSMutableArray *stringsToSort=[NSMutableArray arrayWithObjects:
                                   @"电脑",
                                   @"显示器",
                                   @"你好",
                                   @"推特",
                                   @"乔布斯",
                                   @"再见",
                                   @"暑假作业",
                                   @"键盘",
                                   @"鼠标",
                                   @"谷歌",
                                   @"苹果",
                                   nil];
    
    //Step1输出
    NSLog(@"尚未排序的NSString数组:");
    for(int i=0;i<[stringsToSort count];i++){
        NSLog(@"%@",[stringsToSort objectAtIndex:i]);
    }
    
    
    
    //Step2:获取字符串中文字的拼音首字母并与字符串共同存放
    NSMutableArray *chineseStringsArray=[NSMutableArray array];
    for(int i=0;i<[stringsToSort count];i++){
        ChineseString *chineseString=[[ChineseString alloc]init];
        
        chineseString.string=[NSString stringWithString:[stringsToSort objectAtIndex:i]];
        
        if(chineseString.string==nil){
            chineseString.string=@"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            NSString *pinYinResult=[NSString string];
            for(int j=0;j<chineseString.string.length;j++){
                NSString *singlePinyinLetter=[[NSString stringWithFormat:@"%c",pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult=[pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin=pinYinResult;
        }else{
            chineseString.pinYin=@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //Step2输出
    NSLog(@"\n\n\n转换为拼音首字母后的NSString数组");
    for(int i=0;i<[chineseStringsArray count];i++){
        ChineseString *chineseString=[chineseStringsArray objectAtIndex:i];
        NSLog(@"原String:%@----拼音首字母String:%@",chineseString.string,chineseString.pinYin);
    }
    
    
    
    //Step3:按照拼音首字母对这些Strings进行排序
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    //Step3输出
    NSLog(@"\n\n\n按照拼音首字母后的NSString数组");
    for(int i=0;i<[chineseStringsArray count];i++){
        ChineseString *chineseString=[chineseStringsArray objectAtIndex:i];
        NSLog(@"原String:%@----拼音首字母String:%@",chineseString.string,chineseString.pinYin);
    }
    
    // Step4:如果有需要，再把排序好的内容从ChineseString类中提取出来
    NSMutableArray *result=[NSMutableArray array];
    for(int i=0;i<[chineseStringsArray count];i++){
        [result addObject:((ChineseString*)[chineseStringsArray objectAtIndex:i]).string];
    }
    
    //Step4输出
    NSLog(@"\n\n\n最终结果:");
    for(int i=0;i<[result count];i++){
        NSLog(@"%@",[result objectAtIndex:i]);
    }
    
    
    self.window.backgroundColor = [UIColor whiteColor];
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
