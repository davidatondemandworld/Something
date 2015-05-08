//
//  MsgViewController.h
//  TCPClient-iPhone
//
//  Created by apple on 12-4-7.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "ConnectionDelegate.h"


@interface MsgViewController : UIViewController <ConnectionDelegate> {
    Connection *_connection;
}

@property (nonatomic,retain) IBOutlet UITextField *txtMsg;
@property (nonatomic,retain) IBOutlet UITextView *msgTextView;

- (IBAction) sendMsg;

@end
