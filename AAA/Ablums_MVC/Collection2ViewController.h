//
//  Collection2ViewController.h
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-5.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "CollectionViewController.h"

@interface Collection2ViewController : CollectionViewController<UIActionSheetDelegate>
{
    UIImageView *imageview;
    NSMutableArray *tmpArray;
    UICollectionViewCell *cell;
    NSInteger totle;
    NSMutableArray *nameArray;
    UIActionSheet *action;
    UIActionSheet *action1;
    NSString *title1;
    
    UIBarButtonItem *share;
    UIBarButtonItem *add;
    UIBarButtonItem *del;
}

@end
