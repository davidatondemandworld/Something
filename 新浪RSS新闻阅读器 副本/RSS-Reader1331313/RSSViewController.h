//
//  RSSViewController.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-22.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface RSSViewController : UITableViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    UITextField *_editingTextField;
    NSMutableArray *_allCategory;
    UIBarButtonItem *edit;
    UIBarButtonItem *done;
}
@end
