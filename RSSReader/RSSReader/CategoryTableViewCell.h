//
//  CategoryTableViewCell.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-18.
//
//

#import <UIKit/UIKit.h>

@interface CategoryTableViewCell : UITableViewCell{
    UITextField *_editingTextField;
}

@property (nonatomic,retain) UITextField *editingTextField;

@end
