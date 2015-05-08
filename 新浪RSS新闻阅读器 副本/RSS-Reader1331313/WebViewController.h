//
//  WebViewController.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-26.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView *web;
    IBOutlet UIActivityIndicatorView *activity;
}
@property (nonatomic,copy) NSString *url;
@end
