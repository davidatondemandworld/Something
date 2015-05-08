//
//  videoAppDelegate.h
//  video


#import <UIKit/UIKit.h>

@class videoViewController;

@interface videoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    videoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet videoViewController *viewController;

@end

