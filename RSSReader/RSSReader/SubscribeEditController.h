//
//  SubscribeEditController.h
//  RSSReader
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Channel;

@interface SubscribeEditController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate>{
    Channel *_channel;
    UIView *_channelView;
    UITextField *_inputTextFields[4];
    /*
    UITextField *_titleTextField;
    UITextField *_urlTextField;
    UITextField *_categoryTextField;
    UITextView *_descTextField;
     */
    UIPickerView *_categoryPickerView;
    NSArray *_categories;
}

@property (nonatomic,retain) Channel *channel;

@end
