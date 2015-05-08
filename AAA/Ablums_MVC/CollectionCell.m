//
//  CollectionCell.m
//  Ablums_MVC
//
//  Created by 深圳鲲鹏 on 13-9-5.
//  Copyright (c) 2013年 深圳鲲鹏. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageview = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_imageview];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    _imageview.frame = CGRectInset(self.bounds, 0.0f,0.0f);
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
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
