//
//  ViewController.m
//  ThreadDemo
//
//  Created by  on 12-8-23.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize customerTextField,window1TextView,window2TextView,window3TextView;

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
    
    UIBarButtonItem *btn=[[UIBarButtonItem alloc] initWithTitle:@"Start" style:UIBarButtonItemStylePlain target:self action:@selector(clickStartButton:)];
    self.navigationItem.rightBarButtonItem=btn;
    
    
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

- (void)bankBusinessSimulatorDidStart:(BankBusinessSimulator *)bankBusinessSimulator{    
    NSLog(@"did start");
}

- (void)bankBusinessSimulatorDidFinished:(BankBusinessSimulator *)bankBusinessSimulator{
    NSLog(@"did finished");
}

- (void)bankBusinessSimulator:(BankBusinessSimulator *)bankBusinessSimulator willProcessCustomer:(NSString *)customer onWindow:(NSString *)window{
    NSString *msg=[NSString stringWithFormat:@"will process customer %@",customer];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg",window,@"window", nil];
    
    //self.window1TextView.text=@"wind
    
    //[self updateTextViews:params];            
    [self performSelectorOnMainThread:@selector(updateTextViews:) withObject:params waitUntilDone:NO];
    
    NSLog(@"will process customer %@ on window %@",customer,window);
}

- (void)bankBusinessSimulator:(BankBusinessSimulator *)bankBusinessSimulator processingCustomer:(NSString *)customer onWindow:(NSString *)window{
    NSString *msg=[NSString stringWithFormat:@"processing customer %@",customer];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg",window,@"window", nil];
    //[self updateTextViews:params];

    [self performSelectorOnMainThread:@selector(updateTextViews:) withObject:params waitUntilDone:NO];
    
    NSLog(@"processing customer %@ on window %@",customer,window);
}

- (void)bankBusinessSimulator:(BankBusinessSimulator *)bankBusinessSimulator didProcessedCustomer:(NSString *)customer onWindow:(NSString *)window{
    
    NSString *msg=[NSString stringWithFormat:@"did processed customer %@",customer];
    NSDictionary *params=[NSDictionary dictionaryWithObjectsAndKeys:msg,@"msg",window,@"window", nil];
    //[self updateTextViews:params];
    
    [self performSelectorOnMainThread:@selector(updateTextViews:) withObject:params waitUntilDone:NO];
    
    NSLog(@"did processed customer %@ on window %@",customer,window);
}

#pragma mark - misc

- (void)clickStartButton:(id)sender{  
    NSString *title;
    if (bankBusinessSimulator.state==0) {
        [bankBusinessSimulator start];
        title=@"Stop";
    }
    else if(bankBusinessSimulator.state==1){
        [bankBusinessSimulator stop];
        title=@"Finished";
        [sender setEnabled:NO];
    }
    
    UIBarButtonItem *btn=(UIBarButtonItem *)sender;
    [btn setTitle:title];
}

- (void)clickAddButton:(id)sender{
    NSString *customer=self.customerTextField.text;
    [bankBusinessSimulator enqueueCustomer:customer];
    [self.customerTextField resignFirstResponder];
}

- (void)updateTextViews:(id)params{
    NSString *msg=[params objectForKey:@"msg"];
    NSString *window=[params objectForKey:@"window"];
    UITextView *windowTextView=nil;
    
    if ([@"window_1" isEqualToString:window]) {
        windowTextView=self.window1TextView;
                
    }  
    else if([@"window_2" isEqualToString:window]){
        windowTextView=self.window2TextView;
        //self.window2TextView.text = [NSString stringWithFormat:@"%@\n%@",self.window2TextView.text,msg];
    }
    else{
        windowTextView=self.window3TextView;
        //self.window3TextView.text = [NSString stringWithFormat:@"%@\n%@",self.window3TextView.text,msg];
    }        
    windowTextView.text = [NSString stringWithFormat:@"%@\n%@",windowTextView.text,msg];
    if (windowTextView.contentSize.height>101.0) {        
        CGPoint offset=windowTextView.contentOffset;
        windowTextView.contentOffset=CGPointMake(offset.x, offset.y+22.0);
    }
}

@end
