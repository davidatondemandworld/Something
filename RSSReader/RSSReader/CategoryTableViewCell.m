//
//  CategoryTableViewCell.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-18.
//
//

#import "CategoryTableViewCell.h"

@implementation CategoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _editingTextField=[[UITextField alloc] init];
        _editingTextField.backgroundColor=[UIColor redColor];
        _editingTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_editingTextField];
    }
    return self;
}
- (void)dealloc{
    [_editingTextField release];
    [super dealloc];
}

@synthesize editingTextField=_editingTextField;

- (void)layoutSubviews{
    [super layoutSubviews];
    _editingTextField.frame=self.textLabel.frame;
    [_editingTextField setHidden:!self.isEditing];
    [self.contentView bringSubviewToFront:_editingTextField]; 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
