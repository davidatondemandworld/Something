//
//  WCRegisterViewController.m
//  WeChat
//
//  Created by Reese on 13-8-10.
//  Copyright (c) 2013年 Reese. All rights reserved.
//

#import "WCRegisterViewController.h"


@interface WCRegisterViewController ()

@end

@implementation WCRegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title=@"填写手机号";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.view addSubview:loginNumber];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------注册新用户--------
- (void)startRegister
{
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://www.hcios.com:8080/HCAPI2/servlet/RegisterServlet"]];
    [request setPostValue:userLoginName.text forKey:@"userName"];
    [request setPostValue:userPassword.text forKey:@"userPassword"];
    [request setPostValue:userNickName.text forKey:@"userNickname"];
    [request setPostValue:userDesc.text forKey:@"userDescription"];
    [request setTimeOutSeconds:1000];
    [request setData:UIImageJPEGRepresentation(userHead.imageView.image,0.01) withFileName:[userLoginName.text stringByAppendingString:@"-head.jpg"] andContentType:@"image/jpeg" forKey:@"userHead"];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(requestSuccess:)];
    [request setDidFailSelector:@selector(requestError:)];
    [request startAsynchronous];
    
}


#pragma mark  -------网络请求回调----------
-(void)requestSuccess:(ASIFormDataRequest*)request
{
    SBJsonParser *paser=[[[SBJsonParser alloc]init]autorelease];
    NSDictionary *rootDic=[paser objectWithString:request.responseString];
    int resultCode=[[rootDic objectForKey:@"result_code"]intValue];
    if (resultCode==1) {
        NSLog(@"注册成功");
        //保存账号信息
        //改返回的JSON数据格式请到 www.hcios.com:8080/user下查看
        
        [[NSUserDefaults standardUserDefaults]setObject:[rootDic objectForKey:@"gid"] forKey:kMY_USER_ID];
        [[NSUserDefaults standardUserDefaults]setObject:userLoginName.text forKey:kMY_USER_LoginName];
        [[NSUserDefaults standardUserDefaults]setObject:userPassword.text forKey:kMY_USER_PASSWORD];
        [[NSUserDefaults standardUserDefaults]setObject:[rootDic objectForKey:@"userHead"] forKey:kMY_USER_Head];
        //立刻保存信息
        [[NSUserDefaults standardUserDefaults]synchronize];
        [self.navigationController dismissViewControllerAnimated:YES completion:Nil];
    }else
    {
        NSLog(@"注册失败,原因:%@",[rootDic objectForKey:@"msg"]);
    }
}

#pragma mark  -------请求错误--------
- (void)requestError:(ASIFormDataRequest*)request
{
    NSLog(@"请求失败");
}

#pragma mark   ----触摸取消输入----
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)nextStep:(id)sender{
    if (loginNumber.superview==self.view) {
        [loginNumber removeFromSuperview];
        [self.view addSubview:loginPass];
    }else
    {
        [self startRegister];
    }
    
}


- (void)dealloc {
    [loginNumber release];
    [loginPass release];
    [userLoginName release];
    [userPassword release];
    [userNickName release];
    [userDesc release];
    [userHead release];
    [super dealloc];
}
- (IBAction)changeUserHead:(id)sender {
    UIActionSheet *as=[[UIActionSheet alloc]initWithTitle:@"上传头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"马上照一张" otherButtonTitles:@"从相册中搞一张", nil ];
    [as showInView:self.view];

}



#pragma mark ----------ActionSheet 按钮点击-------------
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"用户点击的是第%d个按钮",buttonIndex);
    switch (buttonIndex) {
        case 0:
            //照一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypeCamera];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:^{
            }];
            
            
            
        }
            break;
        case 1:
            //搞一张
        {
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            [imgPicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [imgPicker setDelegate:self];
            [imgPicker setAllowsEditing:YES];
            [self.navigationController presentViewController:imgPicker animated:YES completion:^{
            }];
            
            
            
            break;
        }
        default:
            break;
    }
    
    
}


#pragma mark ----------图片选择完成-------------
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage  * userHeadImage=[[info objectForKey:@"UIImagePickerControllerEditedImage"]retain];
    
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
        CATransition *trans=[CATransition animation];
        [trans setDuration:0.25f];
        [trans setType:@"flip"];
        [trans setSubtype:kCATransitionFromLeft];
        [userHead.imageView.layer addAnimation:trans forKey:nil];
        
        [userHead.imageView setImage:userHeadImage];
    }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        //
    }];
}

@end
