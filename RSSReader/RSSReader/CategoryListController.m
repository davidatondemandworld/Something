//
//  CategoryViewController.m
//  RSSReader
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "CategoryListController.h"
#import "Utilities.h"
#import "CategoryInfo.h"
#import "CategoryManager.h"
#import "CategoryTableViewCell.h"
#import "ChannelListController.h"
#import "ChannelManager.h"

@interface CategoryListController ()

-(void)clickAddButton:(id)sender;
-(void)clickEditButton:(id)sender;
-(void)clickDoneButton:(id)sender;
-(BOOL)saveTextField:(UITextField *)textField;

@end

@implementation CategoryListController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [_items release];
    [_editButton release];
    [_doneButton release];    
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.title=@"类目";
    

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _editButton=[[UIBarButtonItem alloc] initWithTitle:@"编辑" style:(UIBarButtonItemStyleBordered) target:self action:@selector(clickEditButton:)];
    _doneButton=[[UIBarButtonItem alloc] initWithTitle:@"完成" style:(UIBarButtonItemStyleBordered) target:self action:@selector(clickDoneButton:)];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc]initWithBarButtonSystemItem:(UIBarButtonSystemItemAdd) target:self action:@selector(clickAddButton:)] autorelease];
    self.navigationItem.rightBarButtonItem=_editButton;
    
    _items = [[[CategoryManager defaultManager] allCategories] retain];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)clickAddButton:(id)sender{
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:@"添加类目" message:@"请为此类目输入名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView setAlertViewStyle:(UIAlertViewStylePlainTextInput)];
    [alertView show];
}

#pragma mark - Alert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        UITextField *txt=[alertView textFieldAtIndex:0];
        CategoryInfo *category=[[CategoryInfo alloc] init];
        category.name=txt.text;
        NSError *error=nil;
        int rc=[[CategoryManager defaultManager] saveCategory:category old:nil error:&error];
        if (rc!=0) {
            [error show];
        }
        else{            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:[_items count]-1 inSection:0];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];            
        }
    }
}

#pragma mark - Category editing

- (void)clickEditButton:(id)sender{
    [self.tableView setEditing:YES animated:YES];
    self.navigationItem.rightBarButtonItem=_doneButton;
}

- (void)clickDoneButton:(id)sender{
    if (_editingTextField!=nil) {
        BOOL success=[self saveTextField:_editingTextField];
        if (!success) {
            return;
        }        
    }
    [self.tableView setEditing:NO animated:YES];
    self.navigationItem.rightBarButtonItem=_editButton;
}

-(BOOL)saveTextField:(UITextField *)textField{
    
    UITextField *t=(UITextField *)textField;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:t.tag inSection:0];
    
    CategoryInfo *old=[_items objectAtIndex:indexPath.row];
    CategoryInfo *c=[[[CategoryInfo alloc] init] autorelease];
    c.ID=old.ID;
    c.name=t.text;
    c.orderIndex=old.orderIndex;
    
    NSError *error=nil;
    int rc=[[CategoryManager defaultManager] saveCategory:c old:old error:&error];
    
    if (rc) {
        [error show];
        return NO;
    }
    else{
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    _editingTextField=textField;
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    [self saveTextField:textField];
    _editingTextField=nil;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [self saveTextField:textField];    
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
    return [_items count];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[CategoryTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier] autorelease];
        cell.imageView.image=[UIImage imageNamed:@"folder-rss-1.png"];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.editingTextField.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
    }
    // Configure the cell...
    CategoryInfo *category=[_items objectAtIndex:indexPath.row];
    
    cell.textLabel.text=category.name;
    cell.editingTextField.text=category.name;
    cell.editingTextField.tag=indexPath.row;
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    if (indexPath.row==0) {
        return NO;
    }
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        CategoryInfo *category=[_items objectAtIndex:indexPath.row];
        NSError *error=nil;
        int rc=[[CategoryManager defaultManager] deleteCategory:category error:&error];
        if (rc) {
            [error show];
            return;
        }
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    CategoryInfo *from=[_items objectAtIndex:fromIndexPath.row];
    CategoryInfo *to=[_items objectAtIndex:toIndexPath.row];
    
    int temp=from.orderIndex;
    from.orderIndex=to.orderIndex;
    to.orderIndex=temp; 
    
    [[CategoryManager defaultManager] saveCategory:from old:from error:nil];
    [[CategoryManager defaultManager] saveCategory:to old:to error:nil]; 
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
    ChannelListController *detailViewController = [[ChannelListController alloc] init];     
    // Pass the selected object to the new view controller.
    CategoryInfo *category=[_items objectAtIndex:indexPath.row];
    NSArray *channels=[[ChannelManager defaultManager] channelsByCategoryId:category.ID];
    detailViewController.channels=channels;
    //
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];    
}

@end
