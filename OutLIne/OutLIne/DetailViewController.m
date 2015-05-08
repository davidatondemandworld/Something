//
//  DetailViewController.m
//  OutLIne
//
//  Created by 深圳鲲鹏 on 13-9-17.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "DetailViewController.h"
#import "Article.h"

@interface DetailViewController ()

@end

@implementation DetailViewController
@synthesize array,integer;


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
   
    Article *art = [array objectAtIndex:integer];

    self.navigationItem.title = art._title;
    self.navigationItem.prompt = art._pubDate;
    _textView.text = art._description;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
