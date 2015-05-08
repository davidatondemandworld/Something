//
//  WCLoginViewController.m
//  WeChat
//
//  Created by Reese on 13-8-10.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCLoginViewController.h"
#import "WCRegisterViewController.h"
@interface WCLoginViewController ()

@end

@implementation WCLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self configViews];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_LoginName]) {
        [_userLoginName setText:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_LoginName]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_PASSWORD]) {
        [_userPassword setText:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_PASSWORD]];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_Head]) {
        
        
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_Head]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                CATransition *trans=[CATransition animation];
                [trans setDuration:0.25f];
                [trans setType:@"flip"];
                [trans setSubtype:kCATransitionFromLeft];
                
                [_userHead.layer addAnimation:trans forKey:nil];
                [_userHead setImage:img];

            });
        });
    }
//        [_userLoginName setText:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_LoginName]];
//    }
}

#pragma mark  ----初始化页面------
- (void)configViews
{
    //用户头像
//    [_userHead.layer setShadowColor:[UIColor blackColor].CGColor];
//    [_userHead.layer setShadowOffset:CGSizeMake(-1, -1)];
//    [_userHead.layer setShadowOpacity:0.5f];
    
    //登陆按钮
    [_loginButton setBackgroundImage:[[UIImage imageNamed:@"LoginGreenBigBtn_Hl"]stretchableImageWithLeftCapWidth:10 topCapHeight:15] forState:UIControlStateDisabled];
     [_loginButton setBackgroundImage:[[UIImage imageNamed:@"LoginGreenBigBtn"]stretchableImageWithLeftCapWidth:10 topCapHeight:15] forState:UIControlStateNormal];
    
    //注册按钮
    [_registerButton setBackgroundImage:[[UIImage imageNamed:@"RegistrationHighlight"]stretchableImageWithLeftCapWidth:10 topCapHeight:15] forState:UIControlStateDisabled];
    [_registerButton setBackgroundImage:[[UIImage imageNamed:@"RegistrationNormal"]stretchableImageWithLeftCapWidth:10 topCapHeight:15] forState:UIControlStateNormal];
}


#pragma mark   ----触摸取消输入----
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (modifiedLoginName.text.length!=0) {
        [_userLoginName setText:modifiedLoginName.text];
    }
    [modifiedLoginName setHidden:YES];
    
    [self.view endEditing:YES];
}




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_userHead release];
    [_userLoginName release];
    [_userPassword release];
    [_loginButton release];
    [_registerButton release];
    [mainTab release];
    [modifiedLoginName release];
    [super dealloc];
}

#pragma mark   ----按钮事件----
- (IBAction)registerAccount:(id)sender {
    WCRegisterViewController *registerView=[[[WCRegisterViewController alloc]init]autorelease];
    UINavigationController *regNav=[[[UINavigationController alloc]initWithRootViewController:registerView]autorelease];
    [regNav.navigationBar setTintColor:[UIColor blackColor]];
    [registerView.navigationItem setLeftBarButtonItem:[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelRegister:)]autorelease]];
    [registerView.navigationItem setRightBarButtonItem:[[[UIBarButtonItem alloc]initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:registerView action:@selector(nextStep:)]autorelease]];
    
    [self.navigationController presentViewController:regNav animated:YES completion:^{
        //
    }];
}

- (IBAction)shiftAccount:(id)sender {
    [modifiedLoginName setHidden:NO];
    
}


#pragma mark ------登陆--------


- (IBAction)startLogin:(id)sender {
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.hcios.com:8080/HCAPI2/servlet/LoginServlet"]];
        [request setPostValue:_userLoginName.text forKey:@"userName"];
        [request setPostValue:_userPassword.text forKey:@"userPassword"];
        [request setPostValue:[NSString stringWithFormat:@"WeChat-V%@",[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]] forKey:@"versionInfo"];
    [request setPostValue:[[[UIDevice currentDevice]systemName]stringByAppendingString:[[UIDevice currentDevice]systemVersion]] forKey:@"deviceInfo"];
        [request setDelegate:self];
        [request setDidFinishSelector:@selector(requestSuccess:)];
        [request setDidFailSelector:@selector(requestError:)];
        [request startAsynchronous];

}





#pragma mark  -------网络请求回调----------
-(void)requestSuccess:(ASIFormDataRequest*)request
{
    NSLog(@"response:%@",request.responseString);
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *rootDic=[paser objectWithString:request.responseString];
    int resultCode=[[rootDic objectForKey:@"result_code"]intValue];
    if (resultCode==1) {
        NSLog(@"登陆成功");
        //保存账号信息
        //改返回的JSON数据格式请到 www.hcios.com:8080/user下查看
        NSDictionary *userDic=[rootDic objectForKey:@"data"];
        
        [[NSUserDefaults standardUserDefaults]setObject:[userDic objectForKey:@"userId"] forKey:kMY_USER_ID];
        [[NSUserDefaults standardUserDefaults]setObject:_userPassword.text forKey:kMY_USER_PASSWORD];
        [[NSUserDefaults standardUserDefaults]setObject:[userDic objectForKey:@"userNickname"] forKey:kMY_USER_NICKNAME];
        [[NSUserDefaults standardUserDefaults]setObject:[userDic objectForKey:@"userHead"] forKey:kMY_USER_Head];
        //立刻保存信息
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        
        
        //进入主菜单
        [self.navigationController presentViewController:mainTab animated:YES completion:Nil];
        
    }else
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"登陆失败" message:[rootDic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [av show];
        [av release];
    }
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request
{
    NSLog(@"请求失败");
}



-(void)cancelRegister:(id)sender{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

@end
