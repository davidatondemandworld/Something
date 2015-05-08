//
//  MySwipeGestureRecognizer.m
//  GestureDemo
//
//  Created by andy-tung on 12-4-16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "MySwipeGestureRecognizer.h"


@implementation MySwipeGestureRecognizer

@synthesize direction;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    gestureStartPoint = [touch locationInView:self.view];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPosition = [touch locationInView:self.view];
    
    CGFloat deltaX = fabsf(gestureStartPoint.x - currentPosition.x);
    CGFloat deltaY = fabsf(gestureStartPoint.y - currentPosition.y);
    
    if (deltaX >= kMinimumGestureLength && deltaY <= kMaximumVariance) {
        if(currentPosition.x<gestureStartPoint.x){
            direction = UISwipeGestureRecognizerDirectionLeft;
        }else{
            direction = UISwipeGestureRecognizerDirectionRight;
        }
        [self setState:UIGestureRecognizerStateRecognized];
    }
    else if (deltaY >= kMinimumGestureLength &&
             deltaX <= kMaximumVariance){
        if(currentPosition.y<gestureStartPoint.y){
            direction = UISwipeGestureRecognizerDirectionUp;
        }else{
            direction = UISwipeGestureRecognizerDirectionDown;
        }
        [self setState:UIGestureRecognizerStateRecognized];
    }
}

@end
