//
//  IndexViewController.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-22.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "IndexViewController.h"
#import "GDataXMLNode.h"
#import "Index2ViewController.h"
#import "Channel.h"
#import "AppDelegate.h"

@implementation IndexViewController
@synthesize array;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(NSMutableArray *) rssChannel
{
    UIApplication *app = [UIApplication sharedApplication];
    [app setNetworkActivityIndicatorVisible:YES];
    
    NSString *string = @"http://rss.sina.com.cn/sina_all_opml.xml";
    NSURL *url = [NSURL URLWithString:string];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:data options:XML_PARSE_NOBLANKS error:nil];
    
    NSArray *items = [doc nodesForXPath:@"//opml/body/outline" error:nil];
    
    NSMutableArray *_tmpChannels = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *channelArray = [[NSMutableArray alloc] initWithCapacity:5];
    totalChannels = [[NSMutableArray alloc] initWithCapacity:5];
    
    for (GDataXMLElement *item in items)
    {
        [_tmpChannels addObject:[[item attributeForName:@"title"] stringValue]];
        
        for (GDataXMLElement *node in item.children)
        {
            
            Channel *channel = [[Channel alloc] init];
            channel.title = [[node attributeForName:@"title"] stringValue];
            channel.url = [[node attributeForName:@"xmlUrl"] stringValue];
            [channelArray addObject:channel];
        }
        
        NSArray *tmp = [NSArray arrayWithArray:channelArray];
        [totalChannels addObject:tmp];
        [channelArray removeAllObjects];
    }
    
    return _tmpChannels;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    array = [[NSMutableArray alloc] initWithArray:[self rssChannel]];
    
    if ([array count] == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"warnning", @"警告") message:NSLocalizedString(@"retry", @"重试") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"好的") otherButtonTitles:nil, nil];
        [alert show];
    }
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    self.navigationController.navigationBar.tintColor = app._naviColor;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = self.title;
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
    return [array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // Configure the cell...
//    Channel *channel = [array objectAtIndex:indexPath.row];
//    cell.textLabel.text = channel.title;
    cell.textLabel.text = [array objectAtIndex:indexPath.row];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    Index2ViewController *detailViewController = [[Index2ViewController alloc] initWithStyle:UITableViewStylePlain];
    detailViewController._channels = [totalChannels objectAtIndex:indexPath.row];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
}


@end
