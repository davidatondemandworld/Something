//
//  DetailViewController.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-23.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "DetailViewController.h"
#import "WebViewController.h"
#import "EditViewController.h"
#import "FavouriteViewController.h"
#import "Articles.h"
#import "RSSManager.h"
#import "DetailCell.h"
#import "AppDelegate.h"
@interface DetailViewController ()
-(void)rssButton:(id)sender;
-(void) clickDetailButton:(id)sender;
-(void) clickFavouriteButton:(id)sender;
@end

@implementation DetailViewController
@synthesize channel;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSArray *) rssChannel
{
    NSURL *url = [NSURL URLWithString:self.channel.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSXMLParser *parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    [parser parse];
    
    return _totalDetailChannels;
}

-(void)rssButton:(id)sender
{
    EditViewController *edit = [[EditViewController alloc] initWithNibName:@"EditViewController" bundle:nil];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:edit];
    edit.titleText = channel.title;
    edit.urlText = channel.url;
    [self presentViewController:navi animated:YES completion:nil];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.tintColor = app._naviColor;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationItem.title = self.channel.title;
    
    editButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"periodical", @"订阅") style:UIBarButtonItemStyleDone target:self action:@selector(rssButton:)];
    self.navigationItem.rightBarButtonItem = editButton;
    
    _total = [self rssChannel];
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
    return [_total count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        [cell.detailButton addTarget:self action:@selector(clickDetailButton:) forControlEvents:(UIControlEventTouchUpInside)];
        [cell.favouriteButton addTarget:self action:@selector(clickFavouriteButton:) forControlEvents:(UIControlEventTouchUpInside)];
    }

    DetailChannel *channel1 = [_total objectAtIndex:indexPath.row];
    
    cell.detailButton.tag = indexPath.row;
    cell.favouriteButton.tag = indexPath.row;
    cell.indexPath = indexPath;
    cell.detailChannel = channel1;
        
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailChannel *channel1 = [_total objectAtIndex:indexPath.row];
    channel1.detailVisible = !channel1.detailVisible;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailChannel *channel1 = [_total objectAtIndex:indexPath.row];
    
    if(channel1.detailVisible)
    {
        return 150.0f;
    }
    else
    {
        return 50.0f;
    }
}
-(void)clickDetailButton:(id)sender
{    
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag;
    DetailChannel *channel1 = [_total objectAtIndex:index];
    
    WebViewController *web = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
    
    web.url = channel1.link;
    [self.navigationController pushViewController:web animated:YES];
}

-(void)clickFavouriteButton:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int index = btn.tag;

    DetailChannel *channel1 = [_total objectAtIndex:index];
    
    Articles *article = [[Articles alloc] init];
    article._Title = channel1.title;
    article._URL = channel1.link;
    article._Description = channel1.description;
    
    
    NSArray *array = [[RSSManager defaultManager] selectArticleByTitle:article._Title];
    
    if ([array count] == 0) {
        [[RSSManager defaultManager] addArticle:article error:nil];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"提示") message:NSLocalizedString(@"has collection", @"已收藏") delegate:self cancelButtonTitle:NSLocalizedString(@"I know", @"I know") otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert2 = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"tips", @"提示") message:NSLocalizedString(@"reselect", @"重新选择") delegate:self cancelButtonTitle:NSLocalizedString(@"I know", @"I know") otherButtonTitles:nil, nil];
        [alert2 show];
    }

}

#pragma mark - XML delegate
-(void)parserDidStartDocument:(NSXMLParser *)parser
{
    activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activity.color = [UIColor greenColor];
    activity.frame = CGRectMake(160, 160, 50, 50);
    
    UIApplication *app = [UIApplication sharedApplication];
    [app setNetworkActivityIndicatorVisible:YES];
    [activity startAnimating];    
    
    _totalDetailChannels = [[NSMutableArray alloc] initWithCapacity:5];
    _currentElement = [[NSMutableString alloc] initWithCapacity:5];
}
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    [_currentElement appendFormat:@"/%@",elementName];
    
    if ([@"/rss/channel/item" isEqualToString:_currentElement])
    {
        _detailChannel = [[DetailChannel alloc] init];
    }
}
-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if([@"/rss/channel/item/pubDate" isEqualToString:_currentElement])
    {
        _detailChannel.pubDate = string;
    }
    else if ([@"/rss/channel/item/link" isEqualToString:_currentElement])
    {
        _detailChannel.link = string;
    }
}
-(void)parser:(NSXMLParser *)parser foundCDATA:(NSData *)CDATABlock
{
    if([@"/rss/channel/item/title" isEqualToString:_currentElement])
    {
        _detailChannel.title = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    }
    else if (@"/rss/channel/item/description")
    {
        _detailChannel._description = [[NSString alloc] initWithData:CDATABlock encoding:NSUTF8StringEncoding];
    }
}
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    [_currentElement replaceOccurrencesOfString:[NSString stringWithFormat:@"/%@",elementName] withString:@"" options:NSBackwardsSearch range:NSMakeRange(0, [_currentElement length])];
    
    if ([@"item" isEqualToString:elementName] && [@"/rss/channel" isEqualToString:_currentElement]) {
        [_totalDetailChannels addObject:_detailChannel];
        _detailChannel=nil;
    }

}
-(void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{

}
-(void)parserDidEndDocument:(NSXMLParser *)parser
{
    UIApplication *app = [UIApplication sharedApplication];
    [app setNetworkActivityIndicatorVisible:NO];
    [activity stopAnimating];
}
@end
