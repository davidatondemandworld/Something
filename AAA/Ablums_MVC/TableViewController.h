//
//  TableViewController.h
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-4.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InsertViewController;

@interface TableViewController : UITableViewController<UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSArray *_photos;
    NSMutableArray *_category;
    NSString *_bundlePath;
}
@property (nonatomic,retain) NSArray *_photos;
@property (nonatomic,retain) NSArray *_category;
@property (nonatomic,retain) NSString *_categoryname;
@property (assign) int _indexPath;

@end
