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
        
    bankBusinessSimulator=[[BankBusinessSimulator alloc] init];
    [bankBusinessSimulator setDelegate:self]; 
    
//    [bankBusinessSimulator start];    
    [bankBusinessSimulator enqueueCustomer:@"andy"];
    [bankBusinessSimulator enqueueCustomer:@"peter"];
    [bankBusinessSimulator enqueueCustomer:@"kelly"];  
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

#pragma mark - BankBusinessSimulatorDelegate

- (void)bankBusinessSimulator:(BankBusinessSimulator *)bankBusinessSimulator willProcessCustomer:(NSString *)customer {
    NSString *msg=[NSString stringWithFormat:@"will process customer %@",customer];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg", nil];       
       
    [self performSelectorOnMainThread:@selector(updateTextViews:) withObject:params waitUntilDone:NO];
    
    NSLog(@"will process customer %@",customer);
}

- (void)bankBusinessSimulator:(BankBusinessSimulator *)bankBusinessSimulator processingCustomer:(NSString *)customer {
    NSString *msg=[NSString stringWithFormat:@"processing customer %@",customer];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg", nil];
    //[self updateTextViews:params];

    [self performSelectorOnMainThread:@selector(updateTextViews:) withObject:params waitUntilDone:NO];
    
    NSLog(@"processing customer %@",customer);
}

- (void)bankBusinessSimulator:(BankBusinessSimulator *)bankBusinessSimulator didProcessedCustomer:(NSString *)customer{
    
    NSString *msg=[NSString stringWithFormat:@"did processed customer %@",customer];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg", nil];
    //[self updateTextViews:params];
    
    [self performSelectorOnMainThread:@selector(updateTextViews:) withObject:params waitUntilDone:NO];
    
    NSLog(@"did processed customer %@",customer);
}

#pragma mark - misc

- (void)clickAddButton:(id)sender{
    NSString *customer=self.customerTextField.text;
    [bankBusinessSimulator enqueueCustomer:customer];
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
