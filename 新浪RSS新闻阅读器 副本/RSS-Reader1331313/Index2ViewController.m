//
//  Index2ViewController.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-22.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "Index2ViewController.h"
#import "Channel.h"
#import "DetailViewController.h"
#import "AppDelegate.h"

@implementation Index2ViewController
@synthesize _channels;
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
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.tintColor = app._naviColor;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = NSLocalizedString(@"channel", @"频道");
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
    return [self._channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    Channel *channel = [[Channel alloc] init];
    
    channel = [self._channels objectAtIndex:indexPath.row];
    NSString *title = channel.title;
    NSString *url = channel.url;
    
    cell.textLabel.text = title;
    cell.detailTextLabel.text = url;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    DetailViewController *detailViewController = [[DetailViewController alloc] initWithStyle:UITableViewStylePlain];
     // ...
     // Pass the selected object to the new view controller.
    detailViewController.channel = [self._channels objectAtIndex:indexPath.row];
    
    
     [self.navigationController pushViewController:detailViewController animated:YES];
}

@end
