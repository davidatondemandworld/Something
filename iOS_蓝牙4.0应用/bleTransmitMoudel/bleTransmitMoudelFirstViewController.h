//
//  bleTransmitMoudelFirstViewController.h
//  bleTransmitMoudel
//
//  Created by David on 12-8-6.
//  Copyright (c) 2012年 David. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bleShared.h"

@interface bleTransmitMoudelFirstViewController : UIViewController<UITextFieldDelegate,bleTransmitMoudelAppDelegate>{
    bleShared   *shared;
    UITextField *transmitField;
    
    NSString    *transmitBuffer;
    NSString    *showStringBuffer;
    int16_t     txCounter;
    int16_t     rxCounter;
}
@property (weak, nonatomic) IBOutlet UITextField *txCountField;
@property (weak, nonatomic) IBOutlet UITextField *rxCountField;
@property (weak, nonatomic) IBOutlet UITextView *showTextView;
@property (weak, nonatomic) IBOutlet UILabel *viewLabel;
@property (retain, nonatomic) IBOutlet UITextField *transmitField;

- (IBAction)clearAllButton:(id)sender;
- (IBAction)clearTransmitButton:(id)sender;
- (IBAction)transmitButton:(id)sender;
- (IBAction)backgroundTap:(id)sender;

@end
