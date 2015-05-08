//
//  textToSpeechViewController.h
//  textToSpeech


#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface textToSpeechViewController : UIViewController <NSXMLParserDelegate,AVAudioPlayerDelegate> {
	IBOutlet UITextField *tf;
	
	SystemSoundID soundID;
	AVAudioPlayer *player;	
}

@property (retain) UITextField *tf;
@property (nonatomic, retain) AVAudioPlayer *player;

- (IBAction)playShortSound;
- (IBAction)playLongSound;
- (IBAction) pause;
- (IBAction)skipForward;
- (IBAction)skipBack;
- (IBAction)scrub:(id)sender;
-(IBAction)speak;
-(void)parser:(NSXMLParser*)parser foundCharacters:(NSString*)string;

@end

