//
//  bleTransmitMoudelFirstViewController.m
//  bleTransmitMoudel
//
//  Created by David on 12-8-6.
//  Copyright (c) 2012年 David. All rights reserved.
//

#import "bleTransmitMoudelFirstViewController.h"

@interface bleTransmitMoudelFirstViewController ()

@end

@implementation bleTransmitMoudelFirstViewController
@synthesize txCountField;
@synthesize rxCountField;
@synthesize showTextView;
@synthesize viewLabel;
@synthesize transmitField;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    shared = [[bleShared alloc]init];
    shared.delegate = self;
    
    [(UIControl *)self.view addTarget:self action:@selector(backgroundTap:) forControlEvents:UIControlEventTouchDown];
    //transmitField = [[UITextField alloc] initWithFrame:CGRectMake(20, 300, 200, 30)];
    transmitField.backgroundColor = [UIColor clearColor];
    transmitField.borderStyle = UITextBorderStyleRoundedRect;
    transmitField.textColor = [UIColor redColor];
    transmitField.delegate = self;
    [self.view addSubview:transmitField];
    
    // 设置背景色
    //[self.view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    // 初始化变量
    txCounter = 0;
    rxCounter = 0;
    showStringBuffer = [[NSString alloc]init];
    transmitBuffer = [[NSString alloc]init];
    [self clearAllButton:self];
}

- (void)viewDidUnload
{
    [self setTxCountField:nil];
    [self setRxCountField:nil];
    [self setShowTextView:nil];
    [self setViewLabel:nil];
    [self setTransmitField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation = UIInterfaceOrientationPortrait);
}

#pragma mark - 解决虚拟键盘挡住UITextField的方法
- (void)keyboardWillShow:(NSNotification *)noti
{
    //键盘输入的界面调整
    //键盘的高度
    float height = 265.0;
    CGRect frame = self.view.frame;
    frame.size = CGSizeMake(frame.size.width, frame.size.height - height);
    [UIView beginAnimations:@"Curl"context:nil];//动画开始
    [UIView setAnimationDuration:0.30];
    [UIView setAnimationDelegate:self];
    [self.view setFrame:frame];
    [UIView commitAnimations];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 20.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 265.0);//键盘高度216
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyBoard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if(offset > 0)
    {
        CGRect rect = CGRectMake(0.0f, -offset,width,height);
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}


#pragma mark - 限制文本框输入内容
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSString *temp = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //NSData *data = [temp dataUsingEncoding:NSUTF8StringEncoding];
    char length = temp.length;
    if (length > 5) {
        textField.text = [temp substringToIndex:5];
        viewLabel.text = @"最多输入5个字符";
        return NO;
    }
    return YES;
}


#pragma mark - 触摸背景来关闭虚拟键盘
- (IBAction)backgroundTap:(id)sender {
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    CGRect rect = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    self.view.frame = rect;
    [UIView commitAnimations];
    [transmitField resignFirstResponder];
}


#pragma mark -
#pragma mark BLEDelegate
// 全部完成
- (void) bleReady{
    viewLabel.text = [[NSString alloc]initWithFormat:@"准备完成"];
}

// 显示断开状态

- (void) discoveryDidRefresh{}

#pragma mark -
#pragma mark - BLE TransmitMoudel
/****************************************************************************/
/*                        TransmitMoudel Methods                            */
/****************************************************************************/
// Update UI with TransmitMoudel data received from device
- (void) transmitUpdated:(NSString *)string{
    // 将接到的16进制数据转成ASCII，并在前面叠加"PC:"后面加入换行
    NSString *rxASCII = [[NSString alloc]initWithFormat:@"        PC:"];
    rxASCII = [rxASCII stringByAppendingString:string];
    rxASCII = [rxASCII stringByAppendingString:@"\n"];
    showStringBuffer = [showStringBuffer stringByAppendingString:rxASCII];
    // 接收计数器加1
    rxCounter++;
    [self updateShowTextView];
}

- (void) updataTransmitView{
    // 将接到的16进制数据转成ASCII，并在前面叠加"PC:"后面加入换行
    NSString *txASCII = [[NSString alloc]initWithFormat:@"IP:"];
    txASCII = [txASCII stringByAppendingString:transmitField.text];
    txASCII = [txASCII stringByAppendingString:@"\n"];
    showStringBuffer = [showStringBuffer stringByAppendingString:txASCII];
    // 发送计数器加1
    txCounter++;
    [self updateShowTextView];
    [self backgroundTap:self];
}

- (void) updateShowTextView{
    // 刷新显示
    rxCountField.text = [[NSString alloc]initWithFormat:@"%d", rxCounter];
    txCountField.text = [[NSString alloc]initWithFormat:@"%d", txCounter];
    showTextView.text = showStringBuffer;

    int16_t showTextViewRow = txCounter + rxCounter;
    float f = 17*showTextViewRow;
    if (showTextViewRow > 8) {
        [showTextView setContentOffset:CGPointMake(0, f-130) animated:NO];
    }
}

- (IBAction)clearAllButton:(id)sender{
    rxCountField.text = @"0";
    txCountField.text = @"0";
    showTextView.text = @"";
    showStringBuffer = @"";
    transmitField.text = @"";
    transmitBuffer = @"";
    rxCounter = 0;
    txCounter = 0;
}

- (IBAction)clearTransmitButton:(id)sender{
    transmitField.text = @"";
    transmitBuffer = @"";
}

- (IBAction)transmitButton:(id)sender{
        transmitBuffer = transmitField.text;
        char length = transmitBuffer.length;
        if (length == 5) {
            Byte viewData[5];
            char index;
            NSString *aString;
            for (index = 0; index < length; index++) {
                aString = [transmitBuffer substringWithRange:NSMakeRange(index, 1)];
                sscanf([aString cStringUsingEncoding:NSASCIIStringEncoding], "%s", &viewData[index]);
                if (viewData[index] == 0x00 ) {
                    viewData[index] = 0x20;
                }
            }
            CBPeripheral *aPeripheral = (CBPeripheral *)[shared connectedPeripheral];
            NSData *data = [[NSData alloc]initWithBytes:&viewData length:5];
            [shared write5BytesTransmitDatas:data p:aPeripheral];
            [self updataTransmitView];
            viewLabel.text = @"发送数据成功";
        }
}
@end
