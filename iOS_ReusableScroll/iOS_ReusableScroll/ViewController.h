//
//  ViewController.h
//  iOS_ReusableScroll
//
//  Created by Andy Tung on 13-8-26.
//  Copyright (c) 2013年 Andy Tung (tanghuacheng.cn). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIScrollViewDelegate>{
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIPageControl *_pageControl;
    
    NSInteger _currentIndex;
    NSInteger _padding;    
    NSMutableArray *_photoNames;
}

@property (assign) NSInteger currentIndex;

@end
