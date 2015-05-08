//
//  iPodTestViewController.m
//  iPodTest
//
//  Created by Brandon Trebitowski on 8/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "iPodTestViewController.h"

@implementation iPodTestViewController

@synthesize albumArt;
@synthesize playButton;

- (void)viewDidLoad {
	player = [MPMusicPlayerController iPodMusicPlayer];
	picker = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeAny];
	[picker setDelegate:self];
    [super viewDidLoad];
}

- (void )mediaPicker: (MPMediaPickerController *)mediaPicker didPickMediaItems:(MPMediaItemCollection *)mediaItemCollection {
	[player setQueueWithItemCollection:mediaItemCollection];
	[self dismissModalViewControllerAnimated:YES];
}

- (IBAction) pickMedia:(id) sender {
	[self presentModalViewController:picker animated:YES];
}

- (IBAction) playMedia:(id) sender {
	[player play];
}

- (IBAction) stopMedia:(id) sender {
	if(player)
		[player stop];
}

- (void)dealloc {
    [super dealloc];
	[player release];
	[picker release];
}

@end
