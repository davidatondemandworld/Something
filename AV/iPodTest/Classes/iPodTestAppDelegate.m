//
//  iPodTestAppDelegate.m
//  iPodTest
//
//  Created by Brandon Trebitowski on 8/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "iPodTestAppDelegate.h"
#import "iPodTestViewController.h"

@implementation iPodTestAppDelegate

@synthesize window;
@synthesize viewController;


- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
