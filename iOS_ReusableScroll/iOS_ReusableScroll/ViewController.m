//
//  ViewController.m
//  iOS_ReusableScroll
//
//  Created by Andy Tung on 13-8-26.
//  Copyright (c) 2013年 Andy Tung (tanghuacheng.cn). All rights reserved.
//

#import "ViewController.h"

#define REUSABLE_SIZE 3

@interface ViewController (){
    NSMutableArray *_reusableItems;
    NSString *_bundlePath;
    int width;
    int height;
}

- (void) loadImageViewAtIndex:(NSInteger) index;
- (void) reloadScrollView:(BOOL) resetOffset;

- (void) pageValueChanged:(id)sender;

@end

@implementation ViewController

@synthesize currentIndex=_currentIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];  
    //prepare reusable image view
    _reusableItems=[[NSMutableArray alloc] initWithCapacity:3];
    
    UIImageView *iv=nil;
    for (int i=0; i<3; i++) {
        iv=[[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        [_reusableItems addObject:iv];
        [_scrollView addSubview:iv];
    } 
    
    //set padding between two image view
    _padding=20;
    //prepare datasource
    _photoNames=[[NSMutableArray alloc] initWithCapacity:10];
    for (int i=0; i<10; i++) {
        [_photoNames addObject:[NSString stringWithFormat:@"%i.JPG",i]];
    }
    _bundlePath=[[[NSBundle mainBundle] bundlePath] retain];
    //initialize page control
    [_pageControl addTarget:self action:@selector(pageValueChanged:) forControlEvents:(UIControlEventValueChanged)];
    _pageControl.numberOfPages=[_photoNames count];
    _pageControl.currentPage=_currentIndex;
    //initialize scroll view    
    _scrollView.delegate=self;
    width=_scrollView.frame.size.width;
    height=_scrollView.frame.size.height;
    _scrollView.contentSize=CGSizeMake((width+_padding)*[_photoNames count], height);    
        
    [self reloadScrollView:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)reloadScrollView:(BOOL)resetOffset{
    [self loadImageViewAtIndex:_currentIndex-1];
    [self loadImageViewAtIndex:_currentIndex];
    [self loadImageViewAtIndex:_currentIndex+1];
    if (resetOffset) {
        [_scrollView setContentOffset:CGPointMake((width+_padding)*_currentIndex, 0) animated:YES];
    }
}

-(void)loadImageViewAtIndex:(NSInteger)index{
    if (index<0||index>=[_photoNames count]) {
        return;
    }
    
    UIImageView *iv=_reusableItems[index%REUSABLE_SIZE];
    if (iv.tag!=index+100) {
        NSString *photoName=[NSString stringWithFormat:@"%@/%@",_bundlePath,[_photoNames objectAtIndex:index]];
        iv.image=[[[UIImage alloc] initWithContentsOfFile:photoName] autorelease];
        iv.frame=CGRectMake((width+_padding)*index, 0, width, height);
        iv.tag=index+100;
    }   
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{    
    NSInteger pageIndex=(NSInteger)(scrollView.contentOffset.x/width);
    if (_currentIndex!=pageIndex) {
        _currentIndex=pageIndex;
        [self reloadScrollView:NO];
        _pageControl.currentPage=pageIndex;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    _currentIndex=(NSInteger)(scrollView.contentOffset.x/(width+_padding)+0.5);
    [self reloadScrollView:YES];
    _pageControl.currentPage=_currentIndex;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _currentIndex=(NSInteger)(scrollView.contentOffset.x/(width+_padding)+0.5);
    [self reloadScrollView:YES];
    _pageControl.currentPage=_currentIndex;
}

#pragma mark - UIPageControl
- (void)pageValueChanged:(id)sender{
    _currentIndex=[(UIPageControl *)sender currentPage];    
    [self reloadScrollView:YES];    
}

@end
