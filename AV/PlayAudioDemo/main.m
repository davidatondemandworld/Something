/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ModalMenu.h"

//定义可重用的宏
#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
#define SYSBARBUTTON(ITEM, TARGET, SELECTOR) [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR] autorelease]

//实现协议AVAudioPlayerDelegate
@interface TestBedViewController : UIViewController <AVAudioPlayerDelegate>
{
	AVAudioPlayer *player;              //声音播放器对象
	NSTimer *timer;                     //定时器
	IBOutlet UIProgressView *meter1;    //平均振幅
	IBOutlet UIProgressView *meter2;    //最高振幅
	IBOutlet UISlider *scrubber;        //调节播放进度
	IBOutlet UISlider *volumeSlider;    //调节音量大小
	IBOutlet UILabel *nowPlaying;       //正在播放的音乐名
	NSString *path;
}
@property (retain) AVAudioPlayer *player;
@property (retain) NSString *path;
@end

#define XMAX	30.0f

@implementation TestBedViewController
@synthesize player;
@synthesize path;

- (NSString *) formatTime: (int) num
{
	int secs = num % 60;
	int min = num / 60;
	
	if (num < 60) return [NSString stringWithFormat:@"0:%02d", num];
	
	return	[NSString stringWithFormat:@"%d:%02d", min, secs];
}

//更新进度
- (void) updateMeters
{
	[self.player updateMeters];
	float avg = -1.0f * [self.player averagePowerForChannel:0]; //平均振幅
	float peak = -1.0f * [self.player peakPowerForChannel:0];   //最高振幅
    NSLog(@"%f,%f",[self.player averagePowerForChannel:0],[self.player peakPowerForChannel:0]);
	meter1.progress = (XMAX - avg) / XMAX;
	meter2.progress = (XMAX - peak) / XMAX;
	
	self.title = [NSString stringWithFormat:@"%@ of %@", [self formatTime:self.player.currentTime], [self formatTime:self.player.duration]];
	scrubber.value = (self.player.currentTime / self.player.duration);
}

- (void) pause: (id) sender
{
	if (self.player) [self.player pause];//暂停播放
	self.navigationItem.rightBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemPlay, self, @selector(play:));
	meter1.progress = 0.0f;
	meter2.progress = 0.0f;
	[timer invalidate]; //重新计时
	volumeSlider.enabled = NO;
	scrubber.enabled = NO;
}

- (void) play: (id) sender
{
	if (self.player) [self.player play];//播放音乐

	volumeSlider.value = self.player.volume;//获取音量
	volumeSlider.enabled = YES;
	
    //播放时导航条按钮变成系统暂停按钮，点击时会调用pause方法
	self.navigationItem.rightBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemPause, self, @selector(pause:));
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
	scrubber.enabled = YES;
}

- (void) setVolume: (id) sender
{
	if (self.player) self.player.volume = volumeSlider.value;
}

- (void) scrubbingDone: (id) sender
{
	[self play:nil];
}

- (void) scrub: (id) sender
{
	// Pause the player
	[self.player pause];
	
	// Calculate the new current time
	self.player.currentTime = scrubber.value * self.player.duration;
	
	// Update the title, nav bar
	self.title = [NSString stringWithFormat:@"%@ of %@", [self formatTime:self.player.currentTime], [self formatTime:self.player.duration]];
	self.navigationItem.rightBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemPlay, self, @selector(play:));
}

- (BOOL) prepAudio
{
	NSError *error;
	if (![[NSFileManager defaultManager] fileExistsAtPath:self.path]) return NO;
	
	self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:self.path] error:&error];
	if (!self.player)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	 //播放器初始化完成后就可以准备回放了，该方法预载入播放器的缓冲区并初始化音频回放硬件
	[self.player prepareToPlay];
   
	self.player.meteringEnabled = YES;//启用计量功能就能在回放或录制音频时查看音量
	meter1.progress = 0.0f;
	meter2.progress = 0.0f;
	
    //设置回调
	self.player.delegate = self;
    //在导航条右边显示系统播放按钮，点击时会调用play方法
	self.navigationItem.rightBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemPlay, self, @selector(play:));
	scrubber.enabled = NO;
	
	return YES;
}

//播放完成的回调方法
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	self.navigationItem.rightBarButtonItem = nil;
	scrubber.value = 0.0f;
	scrubber.enabled = NO;
	volumeSlider.enabled = NO;
	[self prepAudio];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    NSLog(@"%@",error);
}

- (void) pick
{
    //选单上的音乐名称
	NSArray *choices = [@"Alexander's Ragtime Band*Hello My Baby*Ragtime Echoes*Rhapsody In Blue*A Tisket A Tasket*In the Mood*Cancel" componentsSeparatedByString:@"*"];//用*号分隔音乐名称
    //mp3文件名称
	NSArray *media = [@"ARB-AJ*HMB1936*ragtime*RhapsodyInBlue*Tisket*InTheMood" componentsSeparatedByString:@"*"];
	
	int answer = [ModalMenu menuWithTitle:@"音乐选单" view:self.view andButtons:choices];
	if (answer == (choices.count - 1)) return;
	
	self.path = [[NSBundle mainBundle] pathForResource:[media objectAtIndex:answer] ofType:@"mp3"];
	nowPlaying.text = [choices objectAtIndex:answer];  
	[self.view viewWithTag:101].hidden = NO;
	[self.player stop];//停止播放
	[self prepAudio];
}

- (void) viewDidLoad
{
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
	self.navigationItem.leftBarButtonItem = BARBUTTON(@"选择音乐", @selector(pick));
	self.path= [[NSBundle mainBundle] pathForResource:@"ARB" ofType:@"mp3"];
}
@end

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@end

@implementation TestBedAppDelegate
- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[TestBedViewController alloc] init]];
	[window addSubview:nav.view];
	[window makeKeyAndVisible];
}
@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
	[pool release];
	return retVal;
}
