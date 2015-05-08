//
//  Cell.m
//  RSS-Reader
//
//  Created by 深圳鲲鹏 on 13-9-28.
//  Copyright (c) 2013年 Bourbon. All rights reserved.
//

#import "Cell.h"

@implementation Cell
@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
//        imageView = [[UIImageView alloc] init];
        textField = [[UITextField alloc] init];
        
//        [self.contentView addSubview:imageView];
        [self.contentView addSubview:textField];
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
//    imageView.frame = CGRectMake(0, 0, 40, 50);
    textField.frame = CGRectMake(50, 10, 200, 30);
    
    UITableView *tb = [self valueForKey:@"tableView"];
    
    textField.enabled = tb.isEditing;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
