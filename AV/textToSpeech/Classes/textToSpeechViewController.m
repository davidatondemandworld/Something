//
//  textToSpeechViewController.m
//  textToSpeech


#import "textToSpeechViewController.h"
#import <AVFoundation/AVFoundation.h> 
@implementation textToSpeechViewController

@synthesize player;
@synthesize tf;

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


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

/*
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}
*/

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}



-(IBAction)speak{
	NSString *loc=[@"http://www.langspeech.com/voiceproxy.php?url=tts4all&langvoc=mdfe01rs&text=" 
				   stringByAppendingString:[tf.text stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
	NSURL *url=[NSURL URLWithString:loc];
	
	NSXMLParser *p = [[NSXMLParser alloc] initWithContentsOfURL:url];
	[p setDelegate:self];
	[p parse];
}

-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string{
	
	if ([string hasPrefix:@"http"]) {
		AVPlayer *player2 = [[AVPlayer playerWithURL:[NSURL URLWithString:string]] retain];
		[player2 play];
	}
}

- (IBAction)playShortSound {
	if (soundID == 0) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"click1" ofType:@"caf"];
		NSURL *url = [NSURL fileURLWithPath:path];
		//注册声音来获取声音ID
		AudioServicesCreateSystemSoundID ((CFURLRef)url, &soundID);
	}
	//播放声音
	AudioServicesPlaySystemSound(soundID);
}

- (void)pause {
	[player pause];
}

- (void)play {	
	[player play];
}

- (IBAction)playLongSound {
	if (!player) {
		NSError *error = nil;
		NSString *path = [[NSBundle mainBundle] pathForResource:@"click1" ofType:@"caf"];
		NSURL *url = [NSURL fileURLWithPath:path];
		
		player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
		player.delegate = self;
	}
	
	if (player.playing) {
		//[self pause];
	} else if (player) {
		[self play];
	}
}

//快进
- (IBAction)skipForward {
	player.currentTime = player.currentTime + 30.0;
}

//后退
- (IBAction)skipBack {
	player.currentTime = player.currentTime - 30.0;
}

- (IBAction)scrub:(id)sender
{
	UISlider *slider = (UISlider *)sender;
	player.currentTime = player.duration * slider.value;
}

- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)thePlayer{
	if (thePlayer == player) {
		[self pause];
	}
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)thePlayer{
	if (thePlayer == player) {
		[self play];
	}
}


- (void)disposeSound {
	if (soundID) {
        //从系统上去掉声音
		AudioServicesDisposeSystemSoundID(soundID);
		soundID = 0;
	}
	
	[player release];
	player = nil;
}

- (void)didReceiveMemoryWarning {
	[self disposeSound];
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
	[tf release];
	[self disposeSound];
    [super dealloc];
}

@end
