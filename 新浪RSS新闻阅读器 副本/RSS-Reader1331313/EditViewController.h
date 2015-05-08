//
//  EditViewController.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-25.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryInfo.h"
@interface EditViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>
{
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *urlLabel;
    IBOutlet UITextField *index;
    IBOutlet UITextField *description;
    IBOutlet UIPickerView *picker;
    IBOutlet UINavigationBar *navi;
    
    int prewTag;
    float prewMoveY;
    
    CategoryInfo *category;
    NSArray *arr;
    
}
@property (nonatomic,copy) NSString *titleText;
@property (nonatomic,copy) NSString *urlText;
@property (nonatomic,copy) NSString *indexText;
@property (nonatomic,copy) NSString *descriptionText;


-(IBAction)clickBackGround:(id)sender;
@end
