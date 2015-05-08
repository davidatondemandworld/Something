//
//  WCFindFriendsViewController.m
//  微信
//
//  Created by Reese on 13-8-11.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCFindFriendsViewController.h"
@class WCUserProfileViewController;

@interface WCFindFriendsViewController ()

@end

@implementation WCFindFriendsViewController

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
    _friendsArray =[[NSMutableArray alloc]init];
    self.navigationItem.title=@"最新注册用户";
    _pageIndex=1;
    [self findFriends];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)findFriends
{
    UIAlertView *av=[[UIAlertView alloc]initWithTitle:@"加载中" message:@"查找最近注册用户中，请稍候" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [av show];
    [av release];
    
    //此API使用方式请查看www.hcios.com:8080/user/findUser.html
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:API_BASE_URL(@"servlet/FindFriendsServlet")];
    
    [request setPostValue:[[NSUserDefaults standardUserDefaults]objectForKey:kMY_USER_ID ] forKey:@"userId"];
    [request setPostValue:[NSNumber numberWithInt:_pageIndex] forKey:@"pageIndex"];
    [request setPostValue:[NSNumber numberWithInt:10] forKey:@"pageSize"];
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
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier]autorelease];
    }
    [cell.textLabel setText:[_friendsArray[indexPath.row]objectForKey:@"userNickname"]];
    [cell.detailTextLabel setText:[_friendsArray[indexPath.row]objectForKey:@"userDescription"]];
    
    
    
    //加载网络头像
    [cell.imageView setImage:[UIImage imageNamed:@"3.jpeg"]];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *img=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[_friendsArray[indexPath.row]objectForKey:@"userHead"]]]];
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
        NSArray *userArr=[rootDic objectForKey:@"users"];
        
        for (NSDictionary *dic in userArr) {
            [_friendsArray addObject:dic];
            WCUserObject *user=[WCUserObject userFromDictionary:dic];
            if (![WCUserObject haveSaveUserById:user.userId]) {
                [WCUserObject saveNewUser:user];
            }
        }
    [_friendTable reloadData];

        
            
    }else
    {
        NSLog(@"查找好友失败,原因:%@",[rootDic objectForKey:@"msg"]);
    }

}


-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y<-100) {
        _pageIndex=1;
        [_friendsArray removeAllObjects];
        [_friendTable reloadData];
        [self findFriends];
    }
    if (scrollView.contentOffset.y>(scrollView.contentSize.height-scrollView.frame.size.height+100)) {
        _pageIndex++;
        [self findFriends];
    }
}


-(void)requestError:(ASIFormDataRequest *)request
{
    NSLog(@"请求失败");
}

-(void)dealloc
{
    [_friendTable release];
    [findView release];
    [web release];
    [super dealloc];
    [_friendsArray release];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WCUserProfileViewController *profileView=[[[WCUserProfileViewController alloc]init]autorelease];
    WCUserObject *user=[[[WCUserObject alloc]init]autorelease];
    NSDictionary *dic=_friendsArray[indexPath.row];
    [user setUserId:[dic objectForKey:@"userId"]];
    [user setUserNickname:[dic objectForKey:@"userNickname"]];
    [user setUserDescription:[dic objectForKey:@"userDescription"]];
    [user setUserHead:[dic objectForKey:@"userHead"]];
    
    
    
    [profileView setThisUser:user];
    [WCUserObject updateUser:user];
    [profileView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:profileView animated:YES];
}

- (IBAction)searchUser:(id)sender {
    [findView setCenter:CGPointMake(160, self.view.frame.size.height/2)];
    [web loadRequest:[NSURLRequest requestWithURL:API_BASE_URL(@"user/addFriend.html")]];
    [self.view addSubview:findView];
    
}

- (IBAction)closeFind:(id)sender {
    [findView removeFromSuperview];
}

- (IBAction)webBack:(id)sender {
    [web goBack];
    
}
@end
