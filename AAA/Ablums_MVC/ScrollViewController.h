//
//  ScrollViewController.h
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-6.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoInfo.h"

@interface ScrollViewController : UIViewController<UIScrollViewDelegate,UIActionSheetDelegate>
{
    IBOutlet UIScrollView *_scrollView;
    
    NSInteger _currentIndex;
    NSInteger _padding;
    NSMutableArray *_photoNames;
    PhotoInfo *name;
    
}
@property (assign) NSInteger _currentIndex;
@property (assign) NSInteger categoryId;
@end
