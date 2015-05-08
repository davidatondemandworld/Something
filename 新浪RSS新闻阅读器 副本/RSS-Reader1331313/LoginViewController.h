//
//  LoginViewController.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-29.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Connection.h"
#import "ConnectionDelegate.h"
@interface LoginViewController : UIViewController<ConnectionDelegate>
{
    Connection *_connection;
    IBOutlet UILabel *_label;
}

-(IBAction)clickBackground:(id)sender;

-(void) login;

@end
