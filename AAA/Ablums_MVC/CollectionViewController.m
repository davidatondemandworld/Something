//
//  CollectionViewController.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-4.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "CollectionViewController.h"
#import "CollectionCell.h"
#import "AppDelegate.h"
#import "PhotoManager.h"
#import "PhotoInfo.h"
#import "PhotoDatabase.h"
#import "ScrollViewController.h"
#import "Collection2ViewController.h"
#import "SlideshowOptionViewController.h"
#define RESEUABLE_CELL_IDENTIFY @"CELL"

@interface CollectionViewController ()

@end

@implementation CollectionViewController
@synthesize items;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;

    [self.collectionView registerClass:[CollectionCell class] forCellWithReuseIdentifier:RESEUABLE_CELL_IDENTIFY];
    self.collectionView.alwaysBounceVertical = YES;
    self.navigationItem.leftBarButtonItem = nil;
    self.collectionView.frame = CGRectMake(0, 47, 320, 460);
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationItem.title = appDel._category;
    self.navigationController.toolbarHidden = NO;
    UIBarButtonItem *select = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(clickShare:)];
    UIBarButtonItem *play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(clickPlay:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    NSArray *tool = [[NSArray alloc] initWithObjects:select,space,play,space, nil];
    self.toolbarItems = tool;
    self.navigationController.toolbar.tintColor = [UIColor colorWithWhite:0.0f alpha:0.7f];
    self.navigationController.toolbar.translucent = YES;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [select release];
    [play release];
    [space release];
    [tool release];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;

    NSArray *array = [[PhotoDatabase sharedDatabase] selectPhotoByCategoryId:appDel._categoryId];
    items = [[NSMutableArray alloc] initWithCapacity:[array count]];
    
    _bundlePath = [[[NSBundle mainBundle] bundlePath] retain];
    
    if([array count] == 0)
    {
        NSString *no_full = [NSString stringWithFormat:@"%@/no_photo_full.png",_bundlePath];
        UIImageView *noimage = [[UIImageView alloc] init];
        noimage.image = [UIImage imageWithContentsOfFile:no_full];
        noimage.frame = CGRectMake(0, 0, 320, 460);
        [self.view addSubview:noimage];
        [noimage release];
    }
    else
    {
        items = [[PhotoDatabase sharedDatabase] selectPhotoByCategoryId:appDel._categoryId];
    }
    
    [self.collectionView reloadData];
}
-(void)clickShare:(id)sender
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(72.0f, 72.0f);
    
    Collection2ViewController *photos2 = [[Collection2ViewController alloc] initWithCollectionViewLayout:flowLayout];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:photos2];
    [self presentViewController:navi animated:NO completion:nil];
}

-(void)clickPlay:(id)sender
{
    SlideshowOptionViewController *slideshow = [[SlideshowOptionViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:slideshow];
    [self presentViewController:navi animated:YES completion:nil];
    [slideshow release];
    [navi release];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [items count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:RESEUABLE_CELL_IDENTIFY forIndexPath:indexPath];
    
    PhotoInfo *photo =[items objectAtIndex:indexPath.row];
    
    NSString *photoname = [NSString stringWithFormat:@"%@/%@",_bundlePath,photo.name];
        
    cell.imageview.image = [UIImage imageWithContentsOfFile:photoname];
//    cell.bounds = CGRectMake(100.0f, 100.0f, 60.0f, 60.0f);
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    appDel.numberOfPhoto = indexPath.row;
    
    ScrollViewController *scroll = [[ScrollViewController alloc] initWithNibName:@"ScrollViewController" bundle:nil];
    [self.navigationController pushViewController:scroll animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
