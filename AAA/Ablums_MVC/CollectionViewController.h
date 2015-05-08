//
//  CollectionViewController.h
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-4.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewController : UICollectionViewController<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSString *_bundlePath;
}
@property (nonatomic,retain) NSMutableArray *items;

@end
