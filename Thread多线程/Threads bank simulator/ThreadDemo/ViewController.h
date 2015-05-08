//
//  ViewController.h
//  ThreadDemo
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BankBusinessSimulator.h"

@interface ViewController : UIViewController<BankBusinessSimulatorDelegate>{
    BankBusinessSimulator *bankBusinessSimulator;
}

@property (nonatomic,retain) IBOutlet UITextField *customerTextField;
@property (nonatomic,retain) IBOutlet UITextView *window1TextView;
@property (nonatomic,retain) IBOutlet UITextView *window2TextView;
@property (nonatomic,retain) IBOutlet UITextView *window3TextView;

- (IBAction)clickStartButton:(id)sender;

- (IBAction)clickAddButton:(id)sender;

- (void) updateTextViews:(id) params;

@end
