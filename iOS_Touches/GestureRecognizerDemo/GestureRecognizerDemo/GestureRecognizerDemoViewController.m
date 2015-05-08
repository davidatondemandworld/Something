//
//  GestureRecognizerDemoViewController.m
//  GestureRecognizerDemo
//
//  Created by apple on 12-4-17.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "GestureRecognizerDemoViewController.h"
#import "MySwipeGestureRecognizer.h"

@implementation GestureRecognizerDemoViewController

- (void)dealloc
{    
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void) handleSwipe:(id) sender{
       
    UISwipeGestureRecognizer *gesture=(UISwipeGestureRecognizer *)sender;

    NSLog(@"swipe direction %i",gesture.direction);
}

- (void) handleTap:(id) sender{
   // UITapGestureRecognizer *gesture=(UITapGestureRecognizer *)sender;
    
    NSLog(@"double tap");

}

- (void) handleMySwipe:(id) sender{
    MySwipeGestureRecognizer *gesture=(MySwipeGestureRecognizer *)sender;
    NSLog(@"swipe:%i",gesture.direction);
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    UISwipeGestureRecognizer *gesture=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
//        gesture.direction = UISwipeGestureRecognizerDirectionUp;
    
//    //UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
//    tap.numberOfTapsRequired=2;
//    
    
    MySwipeGestureRecognizer *gesture=[[MySwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleMySwipe:)];
    
    [self.view addGestureRecognizer:gesture];
    //[self.view addGestureRecognizer:tap];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
