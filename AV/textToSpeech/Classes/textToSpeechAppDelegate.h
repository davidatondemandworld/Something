//
//  textToSpeechAppDelegate.h
//  textToSpeech


#import <UIKit/UIKit.h>

@class textToSpeechViewController;

@interface textToSpeechAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    textToSpeechViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet textToSpeechViewController *viewController;

@end

