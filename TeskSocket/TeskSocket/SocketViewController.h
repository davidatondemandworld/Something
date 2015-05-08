//
//  SocketViewController.h
//  TeskSocket
//
//  Created by apple on 13-5-23.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommunicationViewController.h"
@class SocketAppDelegate;
@interface SocketViewController : UIViewController
{
    CommunicationViewController *communicationController;
}
- (IBAction)enterWasPressed:(id)sender;
- (IBAction)valueChanged:(id)sender;
@property (retain, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@end
