//
//  videoViewController.m
//  video


#import "videoViewController.h"

@implementation videoViewController

@synthesize mpcontrol;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	NSString *loc = [[NSBundle mainBundle] pathForResource:@"sample_iTunes"
													ofType:@"mov"];
	NSURL *url=[NSURL fileURLWithPath:loc];
	mpcontrol = [[MPMoviePlayerController alloc] initWithContentURL:url];

	[self.view addSubview:mpcontrol.view];
	mpcontrol.view.frame = CGRectMake(0, 0, 380, 200);  
	
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
										  selector:@selector(callbackFunction:)  
									      name:MPMoviePlayerPlaybackDidFinishNotification object:mpcontrol];
   
	mpcontrol.fullscreen = YES;
	mpcontrol.scalingMode = MPMovieScalingModeFill;    
	//mpcontrol.controlStyle = MPMovieControlStyleNone;
	
	 [mpcontrol play];
	 [super viewDidLoad];
}


-(void)callbackFunction:(NSNotification*)notification{
	MPMoviePlayerController* video = [notification object];
	[[NSNotificationCenter defaultCenter] removeObserver:self 
										  name:MPMoviePlayerPlaybackDidFinishNotification
										  object:video];
	[video release];
	video = nil;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations    
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[mpcontrol release];
	
    [super dealloc];
}

@end
