//
//  EditViewController.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-25.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "EditViewController.h"
#import "RSSManager.h"
#import "CategoryInfo.h"
#import "ChannelsInfo.h"
#import "AppDelegate.h"
@interface EditViewController ()
@end

@implementation EditViewController
@synthesize titleText,urlText,indexText,descriptionText;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.tintColor = app._naviColor;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIApplication *app = [UIApplication sharedApplication];
    UIInterfaceOrientation currentOrientation = app.statusBarOrientation;
    [self doLayoutForOrientation:currentOrientation];
    
    arr = [[RSSManager defaultManager] allCategory];
    titleLabel.text = self.titleText;
    urlLabel.text = self.urlText;
    
    navi = [[UINavigationBar alloc] init];
    index.inputView = picker;
    [self.view addSubview:navi];
    picker.delegate = self;
    picker.dataSource = self;
    
    [picker selectedRowInComponent:0];
    
    self.navigationItem.title = NSLocalizedString(@"Channel Setting", @"频道编辑");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"关闭") style:(UIBarButtonItemStyleBordered) target:self action:@selector(closeButton:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Save", @"保存") style:(UIBarButtonItemStyleBordered) target:self action:@selector(saveButton:)];
}


-(void)clickBackGround:(id)sender
{
    [self.view endEditing:YES];
}
-(void)saveButton:(id)sender
{
    ChannelsInfo *channel = [[ChannelsInfo alloc] init];
    channel._Title = titleLabel.text;
    channel._Url = urlLabel.text;
    channel._Description = description.text;
    channel._CategoryID = category._ID;
    
    NSMutableArray *array = [[RSSManager defaultManager] selectChannelByTitle:channel._Title];
    if ([array count] > 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"提示") message:NSLocalizedString(@"has collection", @"已收藏") delegate:self cancelButtonTitle:NSLocalizedString(@"I know", @"I know") otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];

    }
    else if ([array count] == 0)
    {
        [[RSSManager defaultManager] addChannel:channel error:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}
-(void)closeButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [arr count];
}
#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CategoryInfo *categery = [arr objectAtIndex:row];
    return categery._Name;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    category = [arr objectAtIndex:row];
    NSString *string = category._Name;
    index.text = string;
}
//适应不同方向
-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self doLayoutForOrientation:toInterfaceOrientation];
}
-(void) doLayoutForOrientation:(UIInterfaceOrientation)orientation
{
    if (UIInterfaceOrientationIsPortrait(orientation)) {
        titleLabel.frame = CGRectMake(100, 62, 97, 30);
        urlLabel.frame = CGRectMake(100, 103, 212, 30);
        index.frame = CGRectMake(100, 141, 97, 30);
        description.frame = CGRectMake(100, 179, 200, 30);
    } else {
        titleLabel.frame = CGRectMake(100, 62, 97, 30);
        urlLabel.frame = CGRectMake(100, 103, 212, 30);
        index.frame = CGRectMake(100, 141, 97, 30);
        description.frame = CGRectMake(100, 179, 200, 30);
    }
}

@end
