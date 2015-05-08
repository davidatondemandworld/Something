//
//  DetailCell.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-28.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "DetailCell.h"
#import "DetailChannel.h"

@implementation DetailCell
@synthesize titleLabel,pubDateLabel,detailButton,favouriteButton,descriptionView,detailChannel,indexPath;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headerView = [[UIView alloc] init];
        
        titleLabel = [[UILabel alloc] init];
        titleLabel.font = [UIFont systemFontOfSize:12.0f];
        titleLabel.textColor = [UIColor blackColor];
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeadherViewTaped:)];
        [titleLabel addGestureRecognizer:gesture];
        titleLabel.userInteractionEnabled = YES;
        [_headerView addSubview:titleLabel];
        
        pubDateLabel = [[UILabel alloc] init];
        pubDateLabel.font = [UIFont systemFontOfSize:10.0f];
        pubDateLabel.textColor = [UIColor grayColor];
        [_headerView addSubview:pubDateLabel];
        
        favouriteButton = [[UIButton alloc] init];
        [favouriteButton setTitle:NSLocalizedString(@"collect", @"收藏") forState:UIControlStateNormal];
        [favouriteButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        favouriteButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_headerView addSubview:favouriteButton];
        
        detailButton = [[UIButton alloc] init];
        [detailButton setTitle:NSLocalizedString(@"all", @"all") forState:(UIControlStateNormal)];
        [detailButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        detailButton.titleLabel.font = [UIFont systemFontOfSize:12.0f];
        [_headerView addSubview:detailButton];

        descriptionView = [[UILabel alloc] init];
        descriptionView.font = [UIFont systemFontOfSize:10.0f];
        descriptionView.textColor = [UIColor grayColor];
        [descriptionView setNumberOfLines:0];
        [descriptionView setLineBreakMode:(NSLineBreakByWordWrapping)];
        
        
        
        [self.contentView addSubview:_headerView];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect rect = self.contentView.frame;
    _headerView.frame = CGRectMake(0.0f, 0.0f, rect.size.width, 50.0f);
    titleLabel.frame = CGRectMake(3.0f, 3.0f, rect.size.width-50.0f, 20.0f);
    pubDateLabel.frame = CGRectMake(3.0f, 26.0f, 100.0f, 20.0f);
    detailButton.frame =CGRectMake(rect.size.width-50.0f, 3.0f, 40.0f, 20.0f);
    favouriteButton.frame = CGRectMake(rect.size.width-50.0f, 26.0f, 40.0f, 20.0f);
    
    descriptionView.frame = CGRectMake(0.0f, 50.0f, rect.size.width, 100.0f);

    if (self.frame.size.height == 50.0f) {
        [descriptionView removeFromSuperview];
    }
    else
    {
        [self.contentView addSubview:descriptionView];
    }
    
}

-(void)setDetailChannel:(DetailChannel *)detailChannel1
{
    titleLabel.text = detailChannel1.title;
    pubDateLabel.text = detailChannel1.pubDate;
    descriptionView.text = detailChannel1._description;
}

-(void)onHeadherViewTaped:(id)sender
{
//    detailChannel.detailVisible = !detailChannel.detailVisible;

    UITableView *tableView = [self valueForKey:@"tableView"];
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
