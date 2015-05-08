//
//  SocketAppDelegate.h
//  TeskSocket
//
//  Created by apple on 13-5-23.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#define APP_DELEGATE [SocketAppDelegate sharedAppDelegate]

enum
{
    kClient = 0,
    kServer
};
typedef NSUInteger HostType;

@class SocketViewController;

@interface SocketAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) SocketViewController *viewController;

@property (strong, nonatomic) UINavigationController *navController;

@property (nonatomic,assign) BOOL isServer;

+ (SocketAppDelegate *)sharedAppDelegate;
@end
