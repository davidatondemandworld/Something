//
//  TCPClient_MacAppDelegate.h
//  TCPClient-Mac
//
//  Created by apple on 12-4-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TCPClient_MacAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
