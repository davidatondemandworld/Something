//
//  GestureRecognizerDemoAppDelegate.h
//  GestureRecognizerDemo
//
//  Created by apple on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GestureRecognizerDemoViewController;

@interface GestureRecognizerDemoAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet GestureRecognizerDemoViewController *viewController;

@end
