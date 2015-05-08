//
//  SelectViewController.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-8.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "SelectViewController.h"
#import "AppDelegate.h"
#import "PhotoDatabase.h"
#import "PhotoManager.h"
#import "PhotoInfo.h"
#define kFlag 103
#define kTitle 105
#define kButton 106

@interface SelectViewController ()
-(void)clickDone:(id)sender;
@end


@implementation SelectViewController

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
	// Do any additional setup after loading the view.
    
    nameArray1 = [[NSMutableArray array] retain];
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@",self.title];
    self.navigationItem.prompt = [NSString stringWithFormat:@"将照片添加到'%@'",self.prompt];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(clickDone:)];
    self.collectionView.frame = CGRectMake(0, 124, 320, 500);
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 74, 320, 50) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    [self.view addSubview:table];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
}

-(void)clickDone:(id)sender
{
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    
    for (PhotoInfo *photo in nameArray1)
    {
        PhotoInfo *aphoto = [[PhotoInfo alloc] init];
        aphoto.name = photo.name;
        aphoto.categoryId = appDel.num;
        
        [[PhotoManager defaultManager] addPhoto:aphoto error:nil];
        
        [aphoto release];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    UIImageView * imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
    imageview.tag = kFlag;
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    NSArray *array = [[PhotoDatabase sharedDatabase] selectPhotoByCategoryId:appDel._categoryId];
    PhotoInfo *photo = [[PhotoInfo alloc] init];
    photo = [array objectAtIndex:indexPath.row];
    
    if(cell.contentView.alpha == 1)
    {
        [cell.contentView addSubview:imageview];
        cell.contentView.alpha = 0.9;
        [nameArray1 addObject:photo];
    }
    else
    {
        if(imageview.tag == kFlag)
        {
            [[cell.contentView.subviews lastObject] removeFromSuperview];
            cell.contentView.alpha = 1;
            
            NSArray *array = [NSArray arrayWithArray:nameArray1];
            
            for (PhotoInfo *info in array)
            {
                if([info.name isEqualToString:photo.name])
                {
                    [nameArray1 removeObject:info];
                }
            }
        }
    }
    
    NSString *prompt1 = [NSString stringWithFormat:@"将%i张照片添加到“%@”",[nameArray1 count],self.prompt];
    self.navigationItem.prompt = prompt1;
    [imageview release];
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = @"选择所有照片";
    button.frame = CGRectMake(280, 74, 50, 50);
    [tableView addSubview:button];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    UIImageView * imageview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right.png"]];
    imageview.tag = kFlag;
    
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    NSArray *array = [[PhotoDatabase sharedDatabase] selectPhotoByCategoryId:appDel._categoryId];

    if(cell.alpha == 1)
    {
        cell.textLabel.text = @"选择所有照片";
        cell.alpha =0.9;
        
        [nameArray1 addObjectsFromArray:array];
    }
    else
    {
        cell.textLabel.text = @"取消选择所有照片";
        cell.alpha = 1;
        
        [nameArray1 removeAllObjects];
    }
}


@end
