//
//  SocketServerChatViewController.m
//  TeskSocket
//
//  Created by zp on 13-5-27.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import "SocketServerChatViewController.h"

@interface SocketServerChatViewController ()

@end

@implementation SocketServerChatViewController

- (void)moveDownTextFieldAndButton
{
    [self.textField resignFirstResponder];
    self.textField.frame = CGRectMake(0, downHeight, self.textField.frame.size.width, self.textField.frame.size.height);
    self.button.frame = CGRectMake(self.button.frame.origin.x, downHeight, self.button.frame.size.width, self.button.frame.size.height);

}
- (IBAction)sendButtonPressed:(id)sender
{
    NSLog(@"发送");
    [self moveDownTextFieldAndButton];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        keyboradHeight = 216;
        screenHeight = 480;
        downHeight = 373;
    }
    else
    {
        keyboradHeight = 264;
        screenHeight = 1024;
        downHeight = 373 +543;
    }
    self.chatTableView.dataSource = self;
    self.chatTableView.delegate = self;
    
    self.textField.delegate = self;
    self.textField.returnKeyType = UIReturnKeyDone;
    [self.textField addTarget:self action:@selector(moveDownTextFieldAndButton) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
- (void)dealloc
{
    [_textField release];
    [_chatTableView release];
    [super dealloc];
}
#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
#pragma mark - UITableView Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    if (indexPath.row%2 == 0)
    {
        cell.textLabel.textAlignment = UITextAlignmentLeft;
        cell.textLabel.text = @"Server:Something";
    }
    else
    {
        cell.textLabel.textAlignment = UITextAlignmentRight;
        cell.textLabel.text = @"Client:Something";
    }

    
    return cell;
}
#pragma mark - UITextField Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.textField.frame = CGRectMake(0, screenHeight-20-keyboradHeight-44-self.textField.frame.size.height, self.textField.frame.size.width, self.textField.frame.size.height);
    self.button.frame = CGRectMake(self.button.frame.origin.x, screenHeight-20-keyboradHeight-44-self.button.frame.size.height, self.button.frame.size.width, self.button.frame.size.height);
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}
@end
