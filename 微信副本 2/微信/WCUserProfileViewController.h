//
//  WCUserProfileViewController.h
//  微信
//
//  Created by Reese on 13-8-14.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WCUserProfileViewController : UIViewController

@property (nonatomic,retain) WCUserObject *thisUser;

- (IBAction)addFirend:(id)sender;
- (IBAction)deleteFriend:(id)sender;

@end
