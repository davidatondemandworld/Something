//
//  WCUserProfileViewController.m
//  微信
//
//  Created by Reese on 13-8-14.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCUserProfileViewController.h"
#import "ASIFormDataRequest.h"

@interface WCUserProfileViewController ()

@end

@implementation WCUserProfileViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}

-(void)dealloc
{
    [super dealloc];
    [_thisUser release];
}

- (IBAction)deleteFriend:(id)sender {
}
- (IBAction)addFirend:(id)sender {
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"加载中" message:@"添加好友中" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [av show];
    [av release];
    _thisUser.friendFlag=[NSNumber numberWithInt:1];
    [WCUserObject updateUser:_thisUser];
    
    //此API使用方式请查看www.hcios.com:8080/user/
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:API_BASE_URL(@"servlet/AddFriendServlet")];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID ] forKey:@"userId"];
    [request setPostValue:_thisUser.userId forKey:@"friendId"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request startAsynchronous];
    [[WCXMPPManager sharedInstance]addSomeBody:_thisUser.userId];
    
}




#pragma mark   -------网络请求回调---------

-(void)requestSuccess:(ASIFormDataRequest*)request
{
    NSLog(@"response:%@",request.responseString);
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *rootDic=[paser objectWithString:request.responseString];
    int resultCode=[[rootDic objectForKey:@"result_code"]intValue];
    if (resultCode==1) {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"成功" message:@"ok" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [av show];
        [av release];
                
    }else
    {
        UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"失败" message:[rootDic objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [av show];
        [av release];
        NSLog(@"查找好友失败,原因:%@",[rootDic objectForKey:@"msg"]);
    }
    
}


-(void)requestError:(ASIFormDataRequest *)request
{
    NSLog(@"请求失败");
}

@end
