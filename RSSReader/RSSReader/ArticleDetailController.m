//
//  ArticleDetailController.m
//  RSSReader
//
//  Created by 深圳鲲鹏 on 13-5-16.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "ArticleDetailController.h"
#import "Article.h"
#import "Utilities.h"

@interface ArticleDetailController ()

@end

@implementation ArticleDetailController

@synthesize article=_article;

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
    _webView=[[UIWebView alloc] initWithFrame:self.view.frame];
    _webView.scalesPageToFit=YES;
    [self.view addSubview:_webView];
    _webView.delegate=self;
    NSURLRequest *req=[NSURLRequest requestWithURL:[NSURL URLWithString:_article.url]];
    [_webView loadRequest:req];    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [error show];
}

@end
