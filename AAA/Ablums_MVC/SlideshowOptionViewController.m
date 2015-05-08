//
//  SlideshowOptionViewController.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-5.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "SlideshowOptionViewController.h"
#import "CollectionViewController.h"
#import "TransitionsViewController.h"
#import "AppDelegate.h"
#define kTagSwitch 103
#define kDuration 0.7   // 动画持续时间(秒)

@interface SlideshowOptionViewController ()

@end

@implementation SlideshowOptionViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    arrayRow = [[NSMutableArray arrayWithObjects:@"过渡",@"播放音乐", nil] retain];
    
    self.navigationItem.title = @"幻灯片显示选项";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if(section == 0)
    {
        return [arrayRow count];
    }
    else
    {
        return 1;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            cell.textLabel.text = [arrayRow objectAtIndex:0];
            AppDelegate *appDel = [UIApplication sharedApplication].delegate;
            cell.detailTextLabel.text = appDel.transitions;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if(indexPath.row == 1)
        {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [arrayRow objectAtIndex:1];
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            [switchview addTarget:self action:@selector(changeSwitch:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchview;
            [switchview release];
        }
        else if(indexPath.row == 2)
        {
            cell.textLabel.text = [arrayRow objectAtIndex:2];
            cell.detailTextLabel.text = @"无";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    if(indexPath.section == 1)
    {
        UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start.png"]];
        cell.accessoryView = image;
        [image release];
    }
    
    return cell;
}
-(void)changeSwitch:(id)sender
{
    if([sender isOn] == YES)
    {
        [arrayRow addObject:@"音乐"];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:([arrayRow count]-1) inSection:0];
        [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [arrayRow removeObjectAtIndex:[sender tag]];
        NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath2] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)cancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if(indexPath.row == 0 && indexPath.section ==0)
    {
        TransitionsViewController *detailViewController = [[TransitionsViewController alloc] initWithStyle:UITableViewStyleGrouped];
        // ...
        // Pass the selected object to the new view controller.
        [self.navigationController pushViewController:detailViewController animated:YES];
        
        [detailViewController release];
    }
    else if (indexPath.row == 0 && indexPath.section == 1)
    {

    }
}

@end
