//
//  SocketShowScreenViewController.m
//  TeskSocket
//
//  Created by apple on 13-6-3.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import "SocketShowScreenViewController.h"

@interface SocketShowScreenViewController ()

@end

@implementation SocketShowScreenViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backWasPressed:(id)sender
{
    [self.presentingViewController dismissModalViewControllerAnimated:YES];
}
- (void)dealloc {
    [_screenView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setScreenView:nil];
    [super viewDidUnload];
}
@end
