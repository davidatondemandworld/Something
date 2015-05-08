//
//  ViewController.m
//  AnimationDemo
//
//  Created by rongfzh on 13-1-14.
//  Copyright (c) 2013年 rongfzh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    redView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    redView.backgroundColor = [UIColor redColor];
    NSString *string1 = [[NSBundle mainBundle] pathForResource:@"image1" ofType:@"jpg"];
    UIImage *image1 = [UIImage imageWithContentsOfFile:string1];
    UIImageView *imageview1 = [[UIImageView alloc] initWithImage:image1];
    imageview1.frame = [[UIScreen mainScreen] bounds];
    [redView addSubview:imageview1];
    [self.view addSubview:redView];
    
    yellowView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    yellowView.backgroundColor = [UIColor yellowColor];
    NSString *string2 = [[NSBundle mainBundle] pathForResource:@"image2" ofType:@"jpg"];
    UIImage *image2 = [UIImage imageWithContentsOfFile:string2];
    UIImageView *imageview2 = [[UIImageView alloc] initWithImage:image2];
    imageview2.frame = [[UIScreen mainScreen] bounds];
    [yellowView addSubview:imageview2];
    [self.view addSubview:yellowView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"改变" forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 10, 300, 40);
    [button addTarget:self action:@selector(changeUIView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"改变1" forState:UIControlStateNormal];
    button1.frame = CGRectMake(10, 60, 300, 40);
    [button1 addTarget:self action:@selector(changeUIView1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"改变2" forState:UIControlStateNormal];
    button2.frame = CGRectMake(10, 110, 300, 40);
    [button2 addTarget:self action:@selector(changeUIView2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    UIButton *button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"改变3" forState:UIControlStateNormal];
    button3.frame = CGRectMake(10, 160, 300, 40);
    [button3 addTarget:self action:@selector(changeUIView3) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    UIButton *button4 = [UIButton buttonWithType:(UIButtonTypeRoundedRect)];
    [button4 setTitle:@"改变4" forState:(UIControlStateNormal)];
    button4.frame = CGRectMake(10, 210, 300, 40);
    [button4 addTarget:self action:@selector(changeUIView4) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:button4];
    
//    moveView = [[UIView alloc] initWithFrame:CGRectMake(10, 200, 200, 40)];
//    moveView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:moveView];

    
}

- (void)changeUIView{
    [UIView beginAnimations:@"animation" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    [UIView commitAnimations];
}

- (void)changeUIView1{
    [UIView beginAnimations:@"animation" context:nil];
	[UIView setAnimationDuration:1.0f];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
    //  交换本视图控制器中2个view位置
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    [UIView setAnimationDidStopSelector:@selector(animationFinish:)];
    [UIView commitAnimations];
}

- (void)changeUIView2{
    //水滴效果
    CATransition *transition = [CATransition animation];
    transition.duration = 2.0f;
    transition.type = @"rippleEffect";
    transition.subtype = kCATransitionFromBottom;
    [self.view exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
    
    [self.view.layer addAnimation:transition forKey:@"animation"];
}

- (void)changeUIView3{
//    [UIView animateWithDuration:3 animations:^(void){
//        moveView.frame = CGRectMake(10, 270, 200, 40);
//    }completion:^(BOOL finished){
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 40, 40)];
//        label.backgroundColor = [UIColor blackColor];
//        [self.view addSubview:label];
//    }];
    
    [UIView animateWithDuration:2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut animations:^(void){
        moveView.alpha = 0.0;
    }completion:^(BOOL finished){
        [UIView animateWithDuration:1
                              delay:1.0
                            options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                         animations:^(void){
                             [UIView setAnimationRepeatCount:2.5];
                             moveView.alpha = 1.0;
                         }completion:^(BOOL finished){
                             
                         }];
        
    }];
}

- (void)changeUIView4
{
    NSArray *viewArray = [self.view subviews];
    __block UIView *tmp1 = [viewArray objectAtIndex:0];
    __block UIView *tmp2 = [viewArray objectAtIndex:1];
    
    [UIView transitionFromView:tmp1 toView:tmp2 duration:2.0 options:(UIViewAnimationOptionTransitionCurlUp) completion:^(BOOL finished) {
        UIView *tmp = tmp1;
        tmp1 = tmp2;
        tmp2 = tmp;
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
