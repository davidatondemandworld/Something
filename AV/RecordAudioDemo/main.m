/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "ModalAlert.h"

#define COOKBOOK_PURPLE_COLOR	[UIColor colorWithRed:0.20392f green:0.19607f blue:0.61176f alpha:1.0f]
#define BARBUTTON(TITLE, SELECTOR) 	[[[UIBarButtonItem alloc] initWithTitle:TITLE style:UIBarButtonItemStylePlain target:self action:SELECTOR] autorelease]
#define SYSBARBUTTON(ITEM, TARGET, SELECTOR) [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:ITEM target:TARGET action:SELECTOR] autorelease]

#define DOCUMENTS_FOLDER [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define FILEPATH [DOCUMENTS_FOLDER stringByAppendingPathComponent:[self dateString]]

#define XMAX	20.0f

@interface TestBedViewController : UIViewController <AVAudioRecorderDelegate, AVAudioPlayerDelegate>
{
	AVAudioRecorder *recorder;
	AVAudioSession *session;
	IBOutlet UIProgressView *meter1;
	IBOutlet UIProgressView *meter2;
	NSTimer *timer;
}
@property (retain) AVAudioSession *session;
@property (retain) AVAudioRecorder *recorder;
@end

@implementation TestBedViewController
@synthesize session;
@synthesize recorder;

//生成录制音频文件的名字
- (NSString *) dateString
{
	// return a formatted string for a file name
	NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
	formatter.dateFormat = @"ddMMMYY_hhmmssa";
	return [[formatter stringFromDate:[NSDate date]] stringByAppendingString:@".aif"];
}
//格式化时间
- (NSString *) formatTime: (int) num
{
	// return a formatted ellapsed time string
	int secs = num % 60;
	int min = num / 60;
	if (num < 60) return [NSString stringWithFormat:@"0:%02d", num];
	return	[NSString stringWithFormat:@"%d:%02d", min, secs];
}

//更新振幅
- (void) updateMeters
{
	// Show the current power levels
	[self.recorder updateMeters];
	float avg = [self.recorder averagePowerForChannel:0];//平均振幅
	float peak = [self.recorder peakPowerForChannel:0];//最高振幅
	meter1.progress = (XMAX + avg) / XMAX;
	meter2.progress = (XMAX + peak) / XMAX;

	// Update the current recording time
	self.title = [NSString stringWithFormat:@"%@", [self formatTime:self.recorder.currentTime]];
}

//播放完成调用
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
	// Prepare UI for recording
	self.title = nil;
	meter1.hidden = NO;
	meter2.hidden = NO;
	{
		// Return to play and record session
		NSError *error;
    //AVAudioSessionCategoryPlayAndRecord:录制并回放的会话
    //AVAudioSessionCategoryRecord:简单录制的会话
    //AVAudioSessionCategoryPlayback:简单回放的会话
    //sharedInstance返回AVAudioSession单例
    
		if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
		{
        //显示本地化的描述信息
			NSLog(@"Error: %@", [error localizedDescription]);
			return;
		}
		self.navigationItem.rightBarButtonItem = BARBUTTON(@"录音", @selector(record));
	}

	// Delete the current recording
	[ModalAlert say:@"正在删除录制的文件..."];
	//[self.recorder deleteRecording]; <-- too flaky to use
	NSError *error;
   //播放完成后删除文件
	if (![[NSFileManager defaultManager] removeItemAtPath:[self.recorder.url path] error:&error])
		NSLog(@"Error: %@", [error localizedDescription]);

	// Release the player
	[player release];
}

//录制完成调用
- (void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
	// Stop monitoring levels, time
	[timer invalidate];//重新计时
	meter1.progress = 0.0f;
	meter1.hidden = YES;
	meter2.progress = 0.0f;
	meter2.hidden = YES;
	self.navigationItem.leftBarButtonItem = nil;
	self.navigationItem.rightBarButtonItem = nil;
	
	[ModalAlert say:@"文件保存到 %@", [[self.recorder.url path] lastPathComponent]];
	self.title = @"正在播放录制的音频...";
	
	// Start playback
	AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
	player.delegate = self;
	
	// Change audio session for playback
	NSError *error;
	if (![[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:&error])
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return;
	}

	[player play];
}

- (void) stopRecording
{
	// This causes the didFinishRecording delegate method to fire
	[self.recorder stop];
}

- (void) continueRecording
{
	// resume from a paused recording
	[self.recorder record];
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Done", @selector(stopRecording));
	self.navigationItem.leftBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemPause, self, @selector(pauseRecording));
}

- (void) pauseRecording
{
	// pause an ongoing recording
	[self.recorder pause];
	self.navigationItem.leftBarButtonItem = BARBUTTON(@"Continue", @selector(continueRecording));
	self.navigationItem.rightBarButtonItem = nil;
}

- (BOOL) record
{
	NSError *error;
	
	// Recording settings
	NSMutableDictionary *settings = [NSMutableDictionary dictionary];
	[settings setValue: [NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
	[settings setValue: [NSNumber numberWithFloat:8000.0] forKey:AVSampleRateKey];
	[settings setValue: [NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey]; // mono
	[settings setValue: [NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsBigEndianKey];
	[settings setValue: [NSNumber numberWithBool:NO] forKey:AVLinearPCMIsFloatKey];
	
	// File URL
	NSURL *url = [NSURL fileURLWithPath:FILEPATH];
	
	// Create recorder
	self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
	if (!self.recorder)
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	// Initialize degate, metering, etc.
	self.recorder.delegate = self;
   //可以获取音量
	self.recorder.meteringEnabled = YES;
	meter1.progress = 0.0f;
	meter2.progress = 0.0f;
	self.title = @"0:00";
	
	if (![self.recorder prepareToRecord])
	{
		NSLog(@"Error: Prepare to record failed");
		[ModalAlert say:@"Error while preparing recording"];
		return NO;
	}
	
	if (![self.recorder record])
	{
		NSLog(@"Error: Record failed");
		[ModalAlert say:@"Error while attempting to record audio"];
		return NO;
	}
	
	// Set a timer to monitor levels, current time
	timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
	
	// Update the navigation bar
	self.navigationItem.rightBarButtonItem = BARBUTTON(@"Done", @selector(stopRecording));
	self.navigationItem.leftBarButtonItem = SYSBARBUTTON(UIBarButtonSystemItemPause, self, @selector(pauseRecording));

	return YES;
}

- (BOOL) startAudioSession
{
	// Prepare the audio session
	NSError *error;
	self.session = [AVAudioSession sharedInstance];
	
	if (![self.session setCategory:AVAudioSessionCategoryPlayAndRecord error:&error])
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	
	if (![self.session setActive:YES error:&error])
	{
		NSLog(@"Error: %@", [error localizedDescription]);
		return NO;
	}
	//inputIsAvailable表示当前设备是否可以访问麦克风
	return self.session.inputIsAvailable;
}

- (void) viewDidLoad
{
	self.navigationController.navigationBar.tintColor = COOKBOOK_PURPLE_COLOR;
	self.title = @"音频记录器";
	//有麦克风就设置导航条右边按钮，点击后调用record方法
	if ([self startAudioSession])
		self.navigationItem.rightBarButtonItem = BARBUTTON(@"录制", @selector(record));
	else
		self.title = @"No Audio Input Available";
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
