//
//  ColorSelectViewController.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-30.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "ColorSelectViewController.h"
#import "AppDelegate.h"

@implementation ColorSelectViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)clickClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    colorArray = @[NSLocalizedString(@"yellow", @"黄色"),NSLocalizedString(@"red",@"红色"),NSLocalizedString(@"blue",@"蓝色"),NSLocalizedString(@"green",@"绿色"),NSLocalizedString(@"black",@"黑色")];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Close", @"关闭") style:(UIBarButtonItemStyleBordered) target:self action:@selector(clickClose:)];
    self.navigationItem.title = NSLocalizedString(@"change color", @"改变颜色");
    
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
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.textLabel.text = [colorArray objectAtIndex:indexPath.row];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    UIColor *yellow= [UIColor yellowColor];
    UIColor *red = [UIColor redColor];
    UIColor *blue = [UIColor blueColor];
    UIColor *green = [UIColor greenColor];
    UIColor *black = [UIColor blackColor];
    NSArray *color = @[yellow,red,blue,green,black];
   
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app._naviColor = [color objectAtIndex:indexPath.row];
        
    [self dismissViewControllerAnimated:YES completion:nil];}

@end
