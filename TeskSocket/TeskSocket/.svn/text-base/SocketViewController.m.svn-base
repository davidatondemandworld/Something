//
//  SocketViewController.m
//  TeskSocket
//
//  Created by apple on 13-5-23.
//  Copyright (c) 2013年 Kid-mind Studios. All rights reserved.
//

#import "SocketViewController.h"
#import "SocketAppDelegate.h"
#import "SocketClientViewController.h"
#import "SocketServerViewController.h"
@interface SocketViewController ()

@end

@implementation SocketViewController

- (void)showCommunicationController
{
    UIViewController *viewController = nil;
    NSString *title = nil;
    if ([SocketAppDelegate sharedAppDelegate].isServer)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            viewController = [[SocketServerViewController alloc] initWithNibName:@"SocketServerViewController_iPhone" bundle:nil];
        }
        else
        {
            viewController = [[SocketServerViewController alloc] initWithNibName:@"SocketServerViewController_iPad" bundle:nil];
        }
        title = @"Server";
    }
    else
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            viewController = [[SocketClientViewController alloc] initWithNibName:@"SocketClientViewController_iPhone" bundle:nil];
        }
        else
        {
            viewController = [[SocketClientViewController alloc] initWithNibName:@"SocketClientViewController_iPad" bundle:nil];
        }
        title = @"Client";
    }
    //[self presentViewController:viewController animated:YES completion:NULL];

    viewController.title = title;
    [self.navigationController pushViewController:viewController animated:YES];
//    if (communicationController == nil)
//    {
//        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
//            communicationController = [[CommunicationViewController alloc] initWithNibName:@"CommunicationViewController_iPhone" bundle:nil];
//        } else {
//            communicationController = [[CommunicationViewController alloc] initWithNibName:@"CommunicationViewController_iPad" bundle:nil];
//        }
//    }
//    [self presentViewController:communicationController animated:YES completion:NULL];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [SocketAppDelegate sharedAppDelegate].isServer = kClient;
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)enter
{
    [self showCommunicationController];
}
- (void)dealloc {
    [_segmentControl release];
    [super dealloc];
}
- (IBAction)enterWasPressed:(id)sender
{
    [self showCommunicationController];
}

- (IBAction)valueChanged:(UISegmentedControl *)sender
{
    [SocketAppDelegate sharedAppDelegate].isServer = sender.selectedSegmentIndex;
}
@end
