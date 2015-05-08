//
//  AppSettingsAppDelegate.h
//  AppSettings
//
//  Created by andy-tung on 12-2-28.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AppSettingsViewController;

@interface AppSettingsAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet AppSettingsViewController *viewController;

@end
