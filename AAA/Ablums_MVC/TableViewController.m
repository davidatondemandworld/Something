//
//  TableViewController.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-4.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "TableViewController.h"
#import "PhotoManager.h"
#import "PhotoInfo.h"
#import "CategoryInfo.h"
#import "CollectionViewController.h"
#import "PhotoDatabase.h"
#import "InsertViewController.h"
#import "AppDelegate.h"
#import "SelectViewController.h"

#define kTagImageView 101
#define kTagName 102


@interface TableViewController ()
-(void)clickAdd:(id)sender;
@end

@implementation TableViewController
@synthesize _category,_photos,_categoryname,_indexPath;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbarHidden = YES;
    
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    
    
    [self.tableView reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _bundlePath = [[[NSBundle mainBundle] bundlePath] retain];
    
    self.navigationItem.title = @"相簿";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(clickAdd:)];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    _category = [[NSMutableArray alloc] initWithCapacity:10];
    _photos = [[[PhotoManager defaultManager] allPhotos] retain];
    _category = [[[PhotoManager defaultManager] allCategory] retain];

}
-(void)clickAdd:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"新建相簿" message:@"请为此相簿输入姓名" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"存储", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert textFieldAtIndex:0].placeholder = @"标题";
    [self alertViewShouldEnableFirstOtherButton:alert];
    [alert show];
    [alert release];
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
    if(buttonIndex == 1)
    {
        NSString *title = [alertView textFieldAtIndex:0].text;

        AppDelegate *appDel = [UIApplication sharedApplication].delegate;
        appDel._phototitle = title;
        
        CategoryInfo *category = [[CategoryInfo alloc] init];
        category.Category = title;
        NSError *error=nil;
        [[PhotoManager defaultManager] addCategory:category error:&error];
        appDel.num = category.myId;
        
        InsertViewController *insert = [[InsertViewController alloc] initWithStyle:UITableViewStylePlain];
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:insert];
        
        
        
        [self presentViewController:navi animated:YES completion:nil];
        
        [insert release];
        [navi release];
        [category release];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_category count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50,0, 270, 50)];
        
        imageview.tag = kTagImageView;
        label.tag = kTagName;
        
        [cell.contentView addSubview:imageview];
        [cell.contentView addSubview:label];
    }
    
    CategoryInfo *category = [_category objectAtIndex:indexPath.row];
    
    NSArray *array = [[NSArray alloc] init];
    array = [[PhotoDatabase sharedDatabase] selectPhotoByCategoryId:(category.myId)];
    
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIImageView *view = (UIImageView *)[cell viewWithTag:kTagImageView];    

    if([array count] == 0)
    {
        NSString *nophoto = @"no_photo.png";
        NSString *photoname = [NSString stringWithFormat:@"%@/%@",_bundlePath,nophoto];
        view.image = [[UIImage alloc] initWithContentsOfFile:photoname];
    }
    else
    {
        PhotoInfo *photo = [array objectAtIndex:0];

        NSString *photoname = [NSString stringWithFormat:@"%@/%@",_bundlePath,photo.name];
        view.image = [[UIImage alloc] initWithContentsOfFile:photoname];
        
        [photo release];

    }
    
    UILabel *lbl = (UILabel *)[cell viewWithTag:kTagName];
    lbl.text = category.Category;
    NSString *detail = [NSString stringWithFormat:@"(%i)",[array count]];
    cell.detailTextLabel.text = detail;
    
    cell.contentView.backgroundColor = [UIColor blackColor];
    return cell;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0)
    {
        return UITableViewCellAccessoryNone;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.

    return YES;

}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete the row from the data source
        _categoryname = [_category objectAtIndex:indexPath.row];
        _indexPath = indexPath.row;
        NSString *title = [NSString stringWithFormat:@"您确定要删除相簿%@吗?照片将不会被删除。",_categoryname];
        UIActionSheet *actionsheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除相簿" otherButtonTitles: nil,nil];
        [actionsheet showInView:self.view];
        [actionsheet release];
    }
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        CategoryInfo *category = [_category objectAtIndex:_indexPath];
        NSError *err;
        [[PhotoManager defaultManager] deleteCategory:category error:&err];
        [self.tableView reloadData];
    }
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    CategoryInfo *category = [_category objectAtIndex:indexPath.row];
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    appDel._category = category.Category;
    appDel._categoryId = category.myId;
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(72.0f, 72.0f);
     CollectionViewController *detailViewController = [[CollectionViewController alloc] initWithCollectionViewLayout:flowLayout];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
}

@end
