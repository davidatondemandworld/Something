//
//  CategoryViewController.h
//  RSSReader
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryListController : UITableViewController<UIAlertViewDelegate,UITextFieldDelegate>{
    NSArray *_items;
    UIBarButtonItem *_editButton;
    UIBarButtonItem *_doneButton;
    UITextField *_editingTextField;
}

@end
