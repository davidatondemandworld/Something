//
//  DetailCell.h
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-28.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DetailChannel;

@interface DetailCell : UITableViewCell
{
    UIView *_headerView;
}
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *pubDateLabel;
@property (nonatomic,strong) UIButton *detailButton;
@property (nonatomic,strong) UIButton *favouriteButton;
@property (nonatomic,strong) UILabel *descriptionView;
@property (nonatomic,strong) DetailChannel *detailChannel;
@property (nonatomic,strong) NSIndexPath *indexPath;
@end
