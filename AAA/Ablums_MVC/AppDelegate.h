//
//  AppDelegate.h
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-3.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,copy) NSString *_phototitle;
@property (assign) int _categoryId;
@property (nonatomic,copy) NSString *_category;
@property (assign) int numberOfPhoto;
@property (nonatomic,copy) NSString *transitions;
@property (assign) int num;

@end
