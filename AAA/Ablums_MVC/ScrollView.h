//
//  ScrollView.h
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-5.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollView : UIScrollView<UIScrollViewDelegate>
{
    UIImageView *_imageView;
    BOOL _larger;
}
@property (nonatomic,retain) UIImageView *imageView;
@property (nonatomic,assign,getter = isLarger) BOOL larger;

@end
