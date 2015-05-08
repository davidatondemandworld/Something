//
//  AppDelegate.h
//  iOS_Html
//
//  Created by Andy Tung on 13-9-13.
//  Copyright (c) 2013年 Andy Tung(tanghuacheng.cn). All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate,NSURLConnectionDataDelegate>{
    NSMutableData *_data;
    NSURLConnection *_connection;
}

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

@end
