//
//  ChannelCategoryListController.m
//  RSSReader
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "ChannelCategoryListController.h"
#import "ChannelSource.h"
#import "ChannelSourceParsing.h"
#import "ChannelListController.h"
#import "Utilities.h"
#import "EasyActivityIndicatorView.h"

@interface ChannelCategoryListController ()

@end

@implementation ChannelCategoryListController

@synthesize channelSource=_channelSource;

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
    
    self.navigationItem.title=_channelSource.name;
    
    
    
    Class class = NSClassFromString(_channelSource.className);
    id<ChannelSourceParsing> parser=(id<ChannelSourceParsing>)[[class alloc] init];
    NSURL *url=[NSURL URLWithString:_channelSource.url];
    /*
    //Sync mode
    NSError *error=nil;
    _channelsDict=[[parser parseURL:url error:&error] retain];
    if (error!=nil) {
        [error show];
        return;
    }
    _categories=[[_channelsDict allKeys] retain]; 
     */
    
    //Async mode    
    _activityIndicatorView=[[EasyActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhiteLarge)];    
    [_activityIndicatorView startAnimating];
    [parser parseURL:url completionHandler:^(NSDictionary *dict, NSError *error) {
        if (error != nil) {
            [error show];            
        }
        else{
            _channelsDict=[dict retain];
            _categories=[[_channelsDict allKeys] retain];
            [self.tableView reloadData];
        }
        [_activityIndicatorView stopAnimating];               
    }];
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if (_categories!=nil) {
        return [_categories count];
    }
    return 0;    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[UITableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        
    }
    // Configure the cell...
    NSString *categoryName=[_categories objectAtIndex:indexPath.row];    
    cell.textLabel.text=categoryName;
    
    return cell;

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
     ChannelListController *detailViewController = [[ChannelListController alloc] init];
     // Pass the selected object to the new view controller.
    NSString *key=[_categories objectAtIndex:indexPath.row];
    NSArray *channels=[_channelsDict objectForKey:key];
    detailViewController.channels=channels;
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}

@end
