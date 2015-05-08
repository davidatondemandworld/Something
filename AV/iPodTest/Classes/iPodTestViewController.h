//
//  iPodTestViewController.h
//  iPodTest
//
//  Created by Brandon Trebitowski on 8/25/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MPMediaPickerController.h>

@interface iPodTestViewController : UIViewController<MPMediaPickerControllerDelegate> {
	UIImageView  * albumArt;
	UIButton     * playButton;
	MPMusicPlayerController  *player;
	MPMediaPickerController * picker;
}

@property (nonatomic, retain) IBOutlet UIImageView * albumArt;
@property (nonatomic, retain) IBOutlet UIButton	   * playButton;

- (IBAction) pickMedia:(id) sender;
- (IBAction) playMedia:(id) sender; 
- (IBAction) stopMedia:(id) sender;

@end

