//
//  SelectViewController.h
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-8.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "CollectionViewController.h"

@interface SelectViewController : CollectionViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *nameArray1;
    UITableView *table;
    UIButton *button;
    
}
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *prompt;
@end
