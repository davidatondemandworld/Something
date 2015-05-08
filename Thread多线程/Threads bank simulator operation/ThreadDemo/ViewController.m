//
//  ViewController.m
//  ThreadDemo
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize customerTextField,window1TextView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization  
        
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    queue = [[NSOperationQueue alloc] init];
    
    BankOperation *operation=[[BankOperation alloc] initWithCustomer:@"andy"];
    [operation setDelegate:self];
    [queue addOperation:operation];
    [operation release];
    
    operation=[[BankOperation alloc] initWithCustomer:@"peter"];
    [operation setDelegate:self];
    [queue addOperation:operation];
    [operation release];
    
    operation=[[BankOperation alloc] initWithCustomer:@"kelly"];
    [operation setDelegate:self];
    [queue addOperation:operation];
    [operation release];   
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

#pragma mark - BankOperationDelegate

- (void)bankOperation:(BankOperation *)bankOperation willProcessCustomer:(NSString *)customer {
    NSString *msg=[NSString stringWithFormat:@"will process customer %@",customer];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg", nil];       
       
    [self performSelectorOnMainThread:@selector(updateTextViews:) withObject:params waitUntilDone:NO];
    
    NSLog(@"will process customer %@",customer);
}

- (void)bankOperation:(BankOperation *)bankOperation processingCustomer:(NSString *)customer {
    NSString *msg=[NSString stringWithFormat:@"processing customer %@",customer];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg", nil];
    //[self updateTextViews:params];

    [self performSelectorOnMainThread:@selector(updateTextViews:) withObject:params waitUntilDone:NO];
    
    NSLog(@"processing customer %@",customer);
}

- (void)bankOperation:(BankOperation *)bankOperation didProcessedCustomer:(NSString *)customer{
    
    NSString *msg=[NSString stringWithFormat:@"did processed customer %@",customer];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg", nil];
    //[self updateTextViews:params];
    
    [self performSelectorOnMainThread:@selector(updateTextViews:) withObject:params waitUntilDone:NO];
    
    NSLog(@"did processed customer %@",customer);
}

#pragma mark - misc

- (void)clickAddButton:(id)sender{
    NSString *customer=self.customerTextField.text;
    
    BankOperation *operation=[[BankOperation alloc] initWithCustomer:customer];
    [operation setDelegate:self];
    [queue addOperation:operation];
    [operation release]; 
    
    [self.customerTextField resignFirstResponder];
}

- (void)updateTextViews:(id)params{
    NSString *msg=[params objectForKey:@"msg"];    
    UITextView *windowTextView=self.window1TextView;    
           
    windowTextView.text = [NSString stringWithFormat:@"%@\n%@",windowTextView.text,msg];
    if (windowTextView.contentSize.height>331.0) {        
        CGPoint offset=windowTextView.contentOffset;
        windowTextView.contentOffset=CGPointMake(offset.x, offset.y+22.0);
    }
}

@end
