//
//  SubscribeEditController.m
//  RSSReader
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "SubscribeEditController.h"
#import <QuartzCore/QuartzCore.h>
#import "CategoryInfo.h"
#import "CategoryManager.h"
#import "Channel.h"
#import "ChannelManager.h"
#import "Utilities.h"

@interface SubscribeEditController ()
- (void) save:(id) sender;
- (void) close:(id)sender;
@end

@implementation SubscribeEditController

@synthesize channel=_channel;

- (id)init{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView{
    [super loadView];
    UINavigationBar *navBar=[[UINavigationBar alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 44.0f)];
    UINavigationItem *navItem=[[UINavigationItem alloc] initWithTitle:@"频道编辑"];
    navItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"保存" style:(UIBarButtonItemStyleBordered) target:self action:@selector(save:)];
    navItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:(UIBarButtonItemStyleBordered) target:self action:@selector(close:)];
    [navBar pushNavigationItem:navItem animated:NO];
    [self.view addSubview:navBar];
    
    
    _channelView = [[UIView alloc] initWithFrame:CGRectMake(10.0f, 50.0f, 300.0f, 160.0f)];
    _channelView.backgroundColor=[UIColor whiteColor];
    _channelView.layer.borderWidth=1.0f;
    _channelView.layer.borderColor=[UIColor grayColor].CGColor;
    _channelView.layer.cornerRadius=5.0f;
    
    for (int i=1; i<4; i++) {
        UIView *line=[[UIView alloc] initWithFrame:CGRectMake(0.0f, i*40.0f, 300.0f, 1.0f)];
        line.backgroundColor=[UIColor lightGrayColor];
        [_channelView addSubview:line];
        [line release];
    }
    
    NSString *titles[4]={@"标题",@"地址",@"类目",@"描述"};
    UILabel *lbl;
    UITextField *txt;
    for (int i=0; i<4; i++) {
        lbl = [[[UILabel alloc] initWithFrame:CGRectMake(20.0f, i*40.0f+5.0f, 40.0f, 30.0f)] autorelease];
        lbl.text=titles[i];
        //lbl.font = [UIFont systemFontOfSize:12.0f];
        //lbl.backgroundColor=[UIColor redColor];
        [_channelView addSubview:lbl];
        
        txt = [[UITextField alloc] initWithFrame:CGRectMake(70.0, i*40.0f+5.0f, 220.0f, 30.0f)];
        //txt.font=[UIFont systemFontOfSize:12.0f];
        txt.textAlignment = UITextAlignmentRight;
        txt.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        //txt.textColor=[UIColor blackColor];        
        //txt.backgroundColor=[UIColor blueColor];
        [_channelView addSubview:txt];
        _inputTextFields[i]=txt;
    }
    
    _categoryPickerView=[[UIPickerView alloc] init];
    _categoryPickerView.showsSelectionIndicator=YES;
    _categoryPickerView.dataSource=self;
    _categoryPickerView.delegate=self;
    _inputTextFields[2].inputView=_categoryPickerView;    
    
    [self.view addSubview:_channelView];
    self.view.backgroundColor=[UIColor lightGrayColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _categories = [[[CategoryManager defaultManager] allCategories] retain];
    
    _inputTextFields[0].text=_channel.title;
    _inputTextFields[1].text=_channel.url;
    if (_channel.categoryId>0) {
        CategoryInfo *category=[[CategoryManager defaultManager] categoryById:_channel.categoryId];
        _inputTextFields[2].text=category.name;
        _inputTextFields[2].tag=category.ID;
    }
    _inputTextFields[3].text=_channel.desc;    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)save:(id)sender{
    Channel *c=[[[Channel alloc] init] autorelease];
    c.ID=_channel.ID;
    c.title=_inputTextFields[0].text;
    c.url=_inputTextFields[1].text;
    c.categoryId=_inputTextFields[2].tag;
    c.desc=_inputTextFields[3].text;
    
    NSError *error=nil;
    Channel *old=_channel.ID>0?_channel:nil;
    int rc=[[ChannelManager defaultManager] saveChannel:c old:old error:&error];
    if (rc) {
        if (error!=nil) {
            [error show];
        }
    }
    else{
         //UIAlertView *alertView=[[[UIAlertView alloc] initWithTitle:@"RSS订阅" message:@"已保存到订阅列表" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil] autorelease];
         //[alertView show];
        [self dismissModalViewControllerAnimated:YES];
    }     
}

- (void)close:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - Picker view datasource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [_categories count];
}

#pragma mark - Picker view delegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    CategoryInfo *category=[_categories objectAtIndex:row];
    return category.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    CategoryInfo *category=[_categories objectAtIndex:row];
    _inputTextFields[2].text=category.name;
    _inputTextFields[2].tag=category.ID;
}

@end
