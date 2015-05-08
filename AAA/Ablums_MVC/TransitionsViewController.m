//
//  TransitionsViewController.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-5.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "TransitionsViewController.h"
#import "SlideshowOptionViewController.h"
#import "AppDelegate.h"
@interface TransitionsViewController ()

@end

@implementation TransitionsViewController

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
    array = [[NSArray alloc] initWithObjects:@"渐隐",@"立体翻转",@"波纹",@"横向擦除",@"向下擦除", nil];
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    // Configure the cell...
    
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    int num = [array indexOfObject:appDel.transitions];
    
    if(indexPath.row == num)
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        cell.textLabel.textColor = [UIColor colorWithRed:0.45 green:0.62 blue:0.82 alpha:1.0];
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    appDel.transitions = [array objectAtIndex:indexPath.row];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
