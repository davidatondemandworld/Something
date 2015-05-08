//
//  ArticleListController.m
//  RSSReader
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "ArticleListController.h"
#import "ArticleTableViewCell.h"
#import "Article.h"
#import "ArticleDetailController.h"
#import "SubscribeEditController.h"
#import "Channel.h"
#import "Utilities.h"

@interface ArticleListController ()

- (void) clickDetailButton:(id)sender;
- (void) clickFavoriteButton:(id)sender;
- (void) clickSubscribeButton:(id)sender;

@end

@implementation ArticleListController

@synthesize articles=_articles;
@synthesize channel=_channel;

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
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem=[[[UIBarButtonItem alloc] initWithTitle:@"订阅" style:(UIBarButtonItemStyleBordered) target:self action:@selector(clickSubscribeButton:)] autorelease];
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
    return [_articles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ArticleTableViewCell *cell = (ArticleTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil) {
        cell=[[[ArticleTableViewCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:CellIdentifier] autorelease];        
        cell.selectionStyle=UITableViewCellSelectionStyleGray;
        [cell.detailButton addTarget:self action:@selector(clickDetailButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.favoriteButton addTarget:self action:@selector(clickFavoriteButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    // Configure the cell...
    Article *article=[_articles objectAtIndex:indexPath.row];
//    cell.titleLabel.text=article.title;
//    cell.dateLabel.text=[article.pubDate stringWithFormat:@"dd/MM HH:mm"];
//    cell.detailButton.tag=indexPath.row;
//    cell.favoriteButton.tag=indexPath.row;    
//    [cell.descriptionView loadHTMLString:article.descriptionHtml baseURL:nil];
    
    cell.indexPath=indexPath;
    cell.article=article;
       
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
    //_selectedCell=(ArticleTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Article *item=[_articles objectAtIndex:indexPath.row];
    if (item.detailVisible) {
        return 150.0f;
    }
    return 50.0f; 
}

#pragma mark click button

- (void)clickDetailButton:(id)sender{
    UIButton *btn=(UIButton*)sender;
    int index=btn.tag;
    Article *article=[_articles objectAtIndex:index];
    
    ArticleDetailController *detailViewController = [[ArticleDetailController alloc] init];
    // Pass the selected object to the new view controller.
    detailViewController.article=article;
    [self.navigationController pushViewController:detailViewController animated:YES];
    //[detailViewController release];
}

- (void)clickFavoriteButton:(id)sender{
    
}

- (void)clickSubscribeButton:(id)sender{
    SubscribeEditController *controller=[[SubscribeEditController alloc] init];
    controller.channel=_channel;
    [self presentModalViewController:controller animated:YES];  
}

@end
