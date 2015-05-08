//
//  ViewController.h
//  ThreadDemo
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankOperation.h"
#import "BankOperationDelegate.h"

@interface ViewController : UIViewController<BankOperationDelegate>{
    NSOperationQueue *queue;
}

@property (nonatomic,retain) IBOutlet UITextField *customerTextField;
@property (nonatomic,retain) IBOutlet UITextView *window1TextView;

- (IBAction)clickAddButton:(id)sender;

- (void) updateTextViews:(id) params;

@end
