//
//  MySwipeGestureRecognizer.h
//  GestureDemo
//
//  Created by andy-tung on 12-4-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

#define kMinimumGestureLength       25
#define kMaximumVariance            5

@interface MySwipeGestureRecognizer : UIGestureRecognizer {
    CGPoint    gestureStartPoint;  
}

@property(nonatomic) UISwipeGestureRecognizerDirection direction;

@end
