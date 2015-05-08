//
//  videoViewController.h
//  video
//


#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface videoViewController : UIViewController {

	MPMoviePlayerController *mpcontrol;
}

@property (nonatomic, retain) MPMoviePlayerController *mpcontrol;

@end

