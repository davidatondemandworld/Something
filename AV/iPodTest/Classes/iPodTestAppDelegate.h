//
//  iPodTestAppDelegate.h
//  iPodTest
//
//  Created by Brandon Trebitowski on 8/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iPodTestViewController;

@interface iPodTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    iPodTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet iPodTestViewController *viewController;

@end

