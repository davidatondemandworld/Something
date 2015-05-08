//
//  DetailViewController.h
//  OutLIne
//
//  Created by 深圳鲲鹏 on 13-9-17.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

{
    IBOutlet UITextView *_textView;
}

@property (nonatomic,retain) NSArray *array;
@property (assign) NSInteger integer;

@end
