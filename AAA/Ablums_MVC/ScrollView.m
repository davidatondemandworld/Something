//
//  ScrollView.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-5.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "ScrollView.h"

@interface ScrollView()
-(void) doubleClickImageView:(id) sender;
@end

@implementation ScrollView
@synthesize imageView = _imageView,larger = _larger;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClickImageView:)];
        ges.numberOfTapsRequired = 2;
        [_imageView addGestureRecognizer:ges];
        [ges release];
        
        [self addSubview:_imageView];
        self.delegate = self;
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    if(_larger)
    {
        _imageView.frame = CGRectMake(0, 0, self.contentSize.width, self.contentSize.height);
    }
    else
    {
        _imageView.frame = self.bounds;
    }
}
-(void)setLarger:(BOOL)larger
{
    if(larger != _larger)
    {
        _larger = larger;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        self.contentSize = _larger?CGSizeMake(self.bounds.size.width*2.0, self.bounds.size.height*2.0):self.bounds.size;
        self.contentOffset=_larger?CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0):CGPointZero;
        [self layoutSubviews];
        [UIView commitAnimations];
    }
}

- (void)doubleClickImageView:(id)sender
{
    [self setLarger:!_larger];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
