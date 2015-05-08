//
//  Collection2ViewController.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-5.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//
#import "CollectionCell.h"
#import "Collection2ViewController.h"
#import "TableViewController.h"
#import "PhotoDatabase.h"
#import "PhotoManager.h"
#import "CategoryInfo.h"
#import "AppDelegate.h"
#import "PhotoInfo.h"
#import "AddToController.h"
#define kFlag 108
#define RESEUABLE_CELL_IDENTIFY @"CELL"

#import "AddToController.h"

@interface Collection2ViewController ()
-(void)addToAblums:(id)sender;
-(void)delete:(id)sender;
@end

@implementation Collection2ViewController

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

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickCancel:)];
    self.navigationItem.title = @"选择照片";
    
    self.collectionView.frame = CGRectMake(0, 47, 320, 460);
    
    share = [[UIBarButtonItem alloc] initWithTitle:@"共享" style:UIBarButtonItemStyleDone target:self action:@selector(shareActivity:)];
    add = [[UIBarButtonItem alloc] initWithTitle:@"添加到" style:UIBarButtonItemStyleDone target:self action:@selector(addToAblums:)];
    del = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(delete:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    share.enabled = NO;
    add.enabled = NO;
    del.enabled = NO;
    share.width = 90.0f;
    add.width = 90.0f;
    del.width = 90.0f;
    del.tintColor = [UIColor redColor];
    NSArray *select = [NSArray arrayWithObjects:share,space,add,space,del, nil];
    self.toolbarItems = select;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    nameArray = [[NSMutableArray array] retain];
    [self.collectionView reloadData];
}
-(void)addToAblums:(id)sender
{
    action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@" 添加到现有的相簿",@"添加到新相簿", nil];
    [action showInView:self.view];
    [action release];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(actionSheet == action)
    {
        if(buttonIndex == 0)
        {
            AddToController *insert = [[AddToController alloc] initWithStyle:UITableViewStylePlain];
            UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:insert];
            
            insert.array = nameArray;
            
            [self presentViewController:navi animated:YES completion:nil];
            [insert release];
            [navi release];
        }
        else if (buttonIndex == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建相簿" message:@"请为此相簿输入姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"存储", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert textFieldAtIndex:0].placeholder = @"标题";
            [self alertViewShouldEnableFirstOtherButton:alert];
            [alert show];
            [alert release];
        }
    }
    else if (actionSheet == action1)
    {
        if(buttonIndex == 0)
        {
            NSArray *array = [NSArray arrayWithArray:nameArray];
            for(int i=0; i<[array count]; i++)
            {
                [[PhotoManager defaultManager] deletePhoto:nameArray[i] error:nil];
            }
            [nameArray removeAllObjects];
//            self.navigationItem.title = @"选择照片";
            [self deleteReload];
            [self.collectionView reloadData];
            [self dismissViewControllerAnimated:NO completion:nil];
        }
    }
}

-(void)deleteReload
{
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    
    self.items = [[PhotoDatabase sharedDatabase] selectPhotoByCategoryId:appDel._categoryId];
}

-(BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView
{
    NSString *title = [alertView textFieldAtIndex:0].text;
    if(title == nil || [title isEqualToString:@""])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        CategoryInfo *category = [[CategoryInfo alloc] init];
        category.Category = [alertView textFieldAtIndex:0].text;
        [[PhotoManager defaultManager] addCategory:category error:nil];
        
        PhotoInfo *bPhoto = [[PhotoInfo alloc] init];
        PhotoInfo *cPhoto = [[PhotoInfo alloc] init];
        for (PhotoInfo *aPhoto in nameArray)
        {
            cPhoto.name = aPhoto.name;
            cPhoto.categoryId = aPhoto.categoryId;
            [[PhotoManager defaultManager] addPhoto:cPhoto error:nil];
            
            bPhoto.name = aPhoto.name;
            bPhoto.categoryId = category.myId;
                        
            [[PhotoManager defaultManager] updatePhoto:cPhoto to:bPhoto error:nil];
        }
        TableViewController *table = [[TableViewController alloc] initWithStyle:UITableViewStylePlain];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:table];
        [self presentViewController:navi animated:YES completion:nil];
        [navi release];
        [table release];
    }
}
-(void)delete:(id)sender
{
    NSString *title = [NSString stringWithFormat:@"您要全部删除吗"];
    NSString *destruct = [NSString stringWithFormat:@"全部删除"];
    
    action1 = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:destruct otherButtonTitles:nil, nil];
    [action1 showInView:self.view];
    [action1 release];
    
}
-(void)shareActivity:(id)sender
{
    NSString *message = @"Hello";
    UIImage *image = [UIImage imageNamed:@"0.JPG"];
    
    NSArray *arrayOfActivityltems = [NSArray arrayWithObjects:message,image, nil];
    
    UIActivityViewController *activityVC = [[[UIActivityViewController alloc] initWithActivityItems:arrayOfActivityltems applicationActivities:nil] autorelease];
    
    [self presentViewController:activityVC animated:YES completion:nil];
    
}
-(void)clickCancel:(id)sender
{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   CollectionCell *cell1 = [collectionView dequeueReusableCellWithReuseIdentifier:RESEUABLE_CELL_IDENTIFY forIndexPath:indexPath];
    
    PhotoInfo *photo =[self.items objectAtIndex:indexPath.row];
    UIView *vw = [cell1.contentView viewWithTag:kFlag];
    
    if(vw)
    {
        [vw removeFromSuperview];
    }
//
    NSString *photoname = [NSString stringWithFormat:@"%@/%@",_bundlePath,photo.name];
//    
    cell1.imageview.image = [UIImage imageWithContentsOfFile:photoname];
    cell1.bounds = CGRectMake(0.0f, 0.0f, 75.0f, 75.0f);
//    
    return cell1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
    imageview.tag = kFlag;
    
    cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSArray *array = [[PhotoDatabase sharedDatabase] selectPhotoByCategoryId:appDel._categoryId];
    
    PhotoInfo *photo = [[PhotoInfo alloc] init];
    photo = [array objectAtIndex:indexPath.row];
    
    if(cell.contentView.alpha == 1)
    {
        [cell.contentView addSubview:imageview];
        cell.contentView.alpha = 0.9;
        [nameArray addObject:photo];        
    }
    else
    {
        if(imageview.tag == kFlag)
        {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
            cell.contentView.alpha = 1;
            
            NSArray *array = [NSArray arrayWithArray:nameArray];
            
            for (PhotoInfo *info in array)
            {
                if([info.name isEqualToString:photo.name])
                {
                    [nameArray removeObject:info];
                }
            }
        }
    }
    
    if([nameArray count] == 0)
    {
        title1 = [NSString stringWithFormat:@"选择照片"];
        share.enabled = NO;
        add.enabled = NO;
        del.enabled = NO;
    }
    else
    {
        
        title1 = [NSString stringWithFormat:@"已选择%i张照片",[nameArray count]];
        share.enabled = YES;
        add.enabled = YES;
        del.enabled = YES;
    }
    self.navigationItem.title = title1;
    
    [imageview release];
}

@end
