//
//  InsertViewController.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-5.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "InsertViewController.h"
#import "CategoryInfo.h"
#import "SelectViewController.h"
#import "AppDelegate.h"
#import "SelectViewController.h"

@interface InsertViewController ()
-(void)clickDone:(id)sender;
@end

@implementation InsertViewController

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
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    NSString *title = [NSString stringWithFormat:@"将照片添加到“%@”",appDel._phototitle];
    self.navigationItem.prompt = title;
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickDone:)] autorelease];
}
-(void)clickDone:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    CategoryInfo *category = [_category objectAtIndex:indexPath.row];
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    appDel._category = category.Category;
    appDel._categoryId = category.myId;
    
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(72.0f, 72.0f);
    
    
    SelectViewController *detailViewController = [[SelectViewController alloc] initWithCollectionViewLayout:flowLayout];
    // ...
    // Pass the selected object to the new view controller.

    detailViewController.title = category.Category;
    detailViewController.prompt = appDel._phototitle;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
