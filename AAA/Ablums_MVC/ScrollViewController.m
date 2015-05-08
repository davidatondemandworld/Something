//
//  ScrollViewController.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-6.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "ScrollViewController.h"
#import "PhotoInfo.h"
#import "ScrollView.h"
#import "AppDelegate.h"
#import "PhotoDatabase.h"
#import "CollectionViewController.h"
#import "SlideshowOptionViewController.h"
#import "PhotoManager.h"
#define REUSABLE_SIZE 5

@interface ScrollViewController ()
{
    NSMutableArray *_reusableItems;
    NSString *_bundlePath;
    int width;
    int height;
}
- (void) loadImageViewAtIndex:(NSInteger) index;
- (void) reloadScrollView:(BOOL) resetOffset;

@end

@implementation ScrollViewController
@synthesize _currentIndex;
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
    // Do any additional setup after loading the view from its nib.
    _scrollView.backgroundColor = [UIColor blackColor];
    _reusableItems = [[NSMutableArray alloc] initWithCapacity:3];
    
    ScrollView *vw = nil;
    for(int i=0; i<5; i++)
    {
        vw = [[[ScrollView alloc] initWithFrame:CGRectZero] autorelease];
        [_reusableItems addObject:vw];
        [_scrollView addSubview:vw];
    }
    _padding = 20;
    
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    _currentIndex = appDel.numberOfPhoto;
    
    _photoNames = [[PhotoDatabase sharedDatabase] selectPhotoByCategoryId:appDel._categoryId];
    
    _bundlePath = [[[NSBundle mainBundle] bundlePath] retain];
    
    _scrollView.delegate = self;
    width = _scrollView.frame.size.width;
    height = _scrollView.frame.size.height;
    _scrollView.contentSize=CGSizeMake((width+_padding)*[_photoNames count], height);
    
    [self reloadScrollView:YES];
    
    NSString *title = [NSString stringWithFormat:@"第%i张 (共%i张)",appDel.numberOfPhoto+1,[_photoNames count]];
 
    
    self.navigationItem.title = title;
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationController.toolbarHidden = NO;
    NSArray *toolBarArray = [[NSArray alloc] init];
    UIBarButtonItem *action = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(clickAction:)];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *play = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(clickPlay:)];
    UIBarButtonItem *del = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clickDel:)];
    toolBarArray = [NSArray arrayWithObjects:action,space,play,space,del, nil];
    self.toolbarItems = toolBarArray;
    
    
}
-(void)clickAction:(id)sender
{    
    NSString *message = @"Hello";
    NSString *filename = [NSString stringWithFormat:@"0.png"];
    UIImage *image = [UIImage imageWithContentsOfFile:[NSString stringWithFormat:@"%@/%@",_bundlePath,filename]];
    
    NSArray *arrayOfActivityltems = [NSArray arrayWithObjects:message,image, nil];
    
    UIActivityViewController *activityVC = [[[UIActivityViewController alloc] initWithActivityItems:arrayOfActivityltems applicationActivities:nil] autorelease];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}
-(void)clickPlay:(id)sender
{
    SlideshowOptionViewController *slideshow = [[SlideshowOptionViewController alloc] initWithStyle:UITableViewStyleGrouped];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:slideshow];
    [self presentViewController:navi animated:YES completion:nil];
    [slideshow release];
    [navi release];
}
-(void)clickDel:(id)sender
{
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    if(appDel._categoryId == 1)
    {
        NSArray *array = [[PhotoDatabase sharedDatabase] selectPhotoByPhotoName:name.name];
        if([array count]==0)
        {
            UIActionSheet *delSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除照片" otherButtonTitles:nil, nil];
            [delSheet showInView:self.view];
            [delSheet release];
        }
        else
        {
            NSString *title = [NSString stringWithFormat:@"此照片用在%i个相簿中，您要全部删除吗?",[array count]];
            UIActionSheet *delSheet = [[UIActionSheet alloc] initWithTitle:title delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"全部删除" otherButtonTitles:nil, nil];
            [delSheet showInView:self.view];
            [delSheet release];
        }

    }
    else
    {
        UIActionSheet *delSheet = [[UIActionSheet alloc] initWithTitle:@"这张照片将从此相簿移除，担任会保留在你的“照片图库”。" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"从相簿中移除" otherButtonTitles:nil, nil];
        [delSheet showInView:self.view];
        [delSheet release];
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    AppDelegate *appDel = [UIApplication sharedApplication].delegate;
    if(buttonIndex == 0)
    {
        if(appDel._categoryId == 1)
        {
            NSArray *array = [[PhotoDatabase sharedDatabase] selectPhotoByPhotoName:name.name];

            PhotoInfo *photo = [array objectAtIndex:0];
            [[PhotoManager defaultManager] deletePhoto:photo error:nil];
            [self reloadScrollView:YES];
        }
        else
        {
            NSArray *array = [[PhotoDatabase sharedDatabase] selectPhotoByCategoryId:appDel._categoryId];
            PhotoInfo *photo = [array objectAtIndex:_currentIndex];

            [[PhotoManager defaultManager] removePhoto:photo error:nil];

            [self reloadScrollView:YES];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)reloadScrollView:(BOOL)resetOffset{
    [self loadImageViewAtIndex:_currentIndex-2];
    [self loadImageViewAtIndex:_currentIndex-1];
    [self loadImageViewAtIndex:_currentIndex];
    [self loadImageViewAtIndex:_currentIndex+1];
    [self loadImageViewAtIndex:_currentIndex+2];

    if (resetOffset)
    {
        [_scrollView setContentOffset:CGPointMake((width+_padding)*_currentIndex, 0) animated:YES];
    }
}

-(void)loadImageViewAtIndex:(NSInteger)index{
    if (index<0||index>=[_photoNames count])
    {
        return;
    }
    ScrollView *vw=_reusableItems[index%REUSABLE_SIZE];
    
    if (vw.tag!=index+100)
    {
        PhotoInfo *info = [_photoNames objectAtIndex:index];
        
        NSString *photoName=[NSString stringWithFormat:@"%@/%@",_bundlePath,info.name];
        vw.imageView.image=[[[UIImage alloc] initWithContentsOfFile:photoName] autorelease];
        vw.frame=CGRectMake((width+_padding)*index, 0, width, height);
        vw.tag=index+100;
    }
    vw.larger=NO;
    name = [_photoNames objectAtIndex:_currentIndex];
}
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSInteger pageIndex=(NSInteger)(scrollView.contentOffset.x/width);
//    if (_currentIndex!=pageIndex)
//    {
//        _currentIndex=pageIndex;
//        NSLog(@"5");
//
//        [self reloadScrollView:NO];
//    }
    NSString *title = [NSString stringWithFormat:@"第%i张 (共%i张)",_currentIndex+1,[_photoNames count]];
    self.navigationItem.title = title;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _currentIndex=(NSInteger)(scrollView.contentOffset.x/(width+_padding)+0.5);
    [self reloadScrollView:YES];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _currentIndex=(NSInteger)(scrollView.contentOffset.x/(width+_padding)+0.5);

    [self reloadScrollView:YES];
}


@end
