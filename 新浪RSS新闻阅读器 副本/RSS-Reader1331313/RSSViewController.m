//
//  RSSViewController.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-22.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "RSSViewController.h"
#import "RSSManager.h"
#import "CategoryInfo.h"
#import "ChannelsViewController.h"
#import "Cell.h"
#import "AppDelegate.h"
#define kImageView 101
#define kTextField 102

@interface RSSViewController ()

-(void) addCategory;
-(void) editCategory;
-(void) doneCategory;
-(BOOL)saveTextField:(UITextField *)textField;
@end

@implementation RSSViewController

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
    _allCategory = [[RSSManager defaultManager] allCategory];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.tintColor = app._naviColor;
    
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.navigationItem.title = NSLocalizedString(@"categroy", @"类目");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCategory)];
        
    edit = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"edit", @"编辑") style:UIBarButtonSystemItemDone target:self action:@selector(editCategory)];
    done = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"done", @"") style:UIBarButtonItemStyleDone target:self action:@selector(doneCategory)];
    
    self.navigationItem.rightBarButtonItem = edit;
}

-(void)editCategory
{
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem = done;
}
-(void)doneCategory
{
    if (_editingTextField != nil) {
        BOOL success = [self saveTextField:_editingTextField];
        if (!success) {
            return;
        }
    }
    
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem = edit;
}
-(void)addCategory
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"add categroy", @"添加类目") message:NSLocalizedString(@"enter name", @"输入名称") delegate:self cancelButtonTitle:NSLocalizedString(@"cannel", @"取消") otherButtonTitles:NSLocalizedString(@"OK",@"确定"), nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *name = [alertView textFieldAtIndex:0].text;
    if (buttonIndex == 1) {
        CategoryInfo *category = [[CategoryInfo alloc] init];
        category._Name = name;
        [[RSSManager defaultManager] addCategory:category error:nil];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField delegate
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _editingTextField = textField;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    [self saveTextField:textField];
    _editingTextField = nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [self saveTextField:textField];
}
-(BOOL)saveTextField:(UITextField *)textField
{
    UITextField *t = (UITextField *)textField;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:t.tag inSection:0];
    CategoryInfo *aCategory = [_allCategory objectAtIndex:indexPath.row];
    CategoryInfo *bCategory = [[CategoryInfo alloc] init];
    bCategory._ID = aCategory._ID;
    bCategory._Name = t.text;
    
    NSError *error = nil;
    int rc = [[RSSManager defaultManager] updateCategory:aCategory to:bCategory error:&error];
    if(rc)
    {
        NSLog(@"%@",error);
        return NO;
    }
    else
    {
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }
    return YES;
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
    return [_allCategory count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    Cell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[Cell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    NSString *string = [[NSBundle mainBundle] pathForResource:@"folder-rss-1" ofType:@"png"];
    
    cell.imageView.image = [UIImage imageWithContentsOfFile:string];
    CategoryInfo *cate = [_allCategory objectAtIndex:indexPath.row];
    cell.textField.text = cate._Name;
    
    
    return cell;
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
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source    
    
        CategoryInfo *category = [_allCategory objectAtIndex:indexPath.row];
        [[RSSManager defaultManager] deleteCategory:category error:nil];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
        
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    ChannelsViewController *detailViewController = [[ChannelsViewController alloc] initWithStyle:UITableViewStylePlain];
    
    CategoryInfo *cate = [_allCategory objectAtIndex:indexPath.row];
        
    detailViewController._cate = cate._ID;
    // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
