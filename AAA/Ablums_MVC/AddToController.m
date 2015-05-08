//
//  AddToController.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-8.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "TableViewController.h"
#import "AddToController.h"
#import "PhotoManager.h"
#import "PhotoInfo.h"
#import "CategoryInfo.h"
#import "CollectionViewController.h"

@interface AddToController ()
-(void)clickCancel:(id)sender;
@end

@implementation AddToController

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
    self.navigationItem.title = @"添加到相簿";
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(clickCancel:)] autorelease];
}
-(void)clickCancel:(id)sender
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
    
    PhotoInfo *bphoto = [[PhotoInfo alloc] init];
    bphoto.categoryId = category.myId;
    
    for(int i=0; i<[self.array count]; i++)
    {
        PhotoInfo *aphoto = [self.array objectAtIndex:i];

        bphoto.name = aphoto.name;
        
        [[PhotoManager defaultManager] updatePhoto:aphoto to:bphoto error:nil];
    
        [aphoto release];
    }
    
    [bphoto release];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
