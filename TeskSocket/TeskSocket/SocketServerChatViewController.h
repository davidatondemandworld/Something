//
//  SocketServerChatViewController.h
//  TeskSocket
//
//  Created by zp on 13-5-27.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocketServerChatViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    CGFloat keyboradHeight;
    CGFloat screenHeight;
    CGFloat downHeight;
}
@property (nonatomic, retain) IBOutlet UITableView *chatTableView;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UIButton *button;
- (IBAction)sendButtonPressed:(id)sender;
@end
