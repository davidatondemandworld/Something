//
//  WCContactsViewController.m
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCContactsViewController.h"
#import "WCSendMessageController.h"

@interface WCContactsViewController ()

@end

@implementation WCContactsViewController

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
    self.navigationItem.title=@"通讯录";
    _friendsArray=[[NSMutableArray alloc]init];
    [self getFriends];
    UIBarButtonItem *barBtn=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    [self.navigationItem setRightBarButtonItem:barBtn];
    [barBtn release];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_friendsArray release];
    _friendsArray=[WCUserObject fetchAllFriendsFromLocal];
    [_friendTable reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getFriends
{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"加载中" message:@"刷新好友列表中，请稍候" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [av show];
    [av release];
    
    //此API使用方式请查看www.hcios.com:8080/user/findUser.html
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:API_BASE_URL(@"servlet/GetFriendListServlet")];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID ] forKey:@"userId"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request startAsynchronous];
}



#pragma mark   ---------tableView协议----------------
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _friendsArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * identifier=@"friendCell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    WCUserObject *user=_friendsArray[indexPath.row];
    [cell.textLabel setText:user.userNickname];
    [cell.detailTextLabel setText:user.userDescription?user.userDescription:@"这个家伙很懒什么都没留下"];
    
    
    
    //加载网络头像
    [cell.imageView setImage:[UIImage imageNamed:@"3.jpeg"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:user.userHead]]];
        dispatch_async(dispatch_get_main_queue(), ^{
            CATransition *trans=[CATransition animation];
            [trans setDuration:0.25f];
            [trans setType:@"flip"];
            [trans setSubtype:kCATransitionFromLeft];
            
            [cell.imageView.layer addAnimation:trans forKey:nil];
            [cell.imageView setImage:img];
            
        });
    });
    
    return cell;
}

#pragma mark   -------网络请求回调---------

-(void)requestSuccess:(ASIFormDataRequest*)request
{
    NSLog(@"response:%@",request.responseString);
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *rootDic=[paser objectWithString:request.responseString];
    int resultCode=[[rootDic objectForKey:@"result_code"]intValue];
    if (resultCode==1) {
        NSLog(@"查找成功");
        //保存账号信息
        //改返回的JSON数据格式请到 www.hcios.com:8080/user下查看
        NSArray *userArr=[rootDic objectForKey:@"friends"];
        
        for (NSDictionary *dic in userArr) {
            
            WCUserObject *user=[WCUserObject userFromDictionary:dic];
            [user setFriendFlag:[NSNumber numberWithInt:1]];
            
            if (![WCUserObject haveSaveUserById:user.userId]) {
                [WCUserObject saveNewUser:user];
                [_friendsArray addObject:user];
            }
            else [WCUserObject updateUser:user];
        }
        [_friendTable reloadData];
        
        
        
    }else
    {
        NSLog(@"查找好友失败,原因:%@",[rootDic objectForKey:@"msg"]);
    }
    
}


-(void)requestError:(ASIFormDataRequest *)request
{
    NSLog(@"请求失败");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCSendMessageController *sendView=[[[WCSendMessageController alloc]init]autorelease];
    WCUserObject *user=_friendsArray[indexPath.row];

    
    
    [sendView setChatPerson:user];
    [sendView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:sendView animated:YES];
}

- (void)dealloc {
    [_friendTable release];
    [_friendsArray release];
    [super dealloc];
}


-(void)refresh:(id)sender
{
    [self getFriends];
}
@end
