//
//  ArticleTableViewCell.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-19.
//
//

#import <UIKit/UIKit.h>
@class Article;

@interface ArticleTableViewCell : UITableViewCell{
    UIView *_headerView;
    UILabel *_titleLabel;
    UILabel *_dateLabel;
    UIButton *_favoriteButton;
    UIButton *_detailButton;
    UIWebView *_descriptionView;
    NSIndexPath *_indexPath;
    
    Article *_article;
    
}

@property (nonatomic,readonly) UILabel *titleLabel;
@property (nonatomic,readonly) UILabel *dateLabel;
@property (nonatomic,readonly) UIButton *favoriteButton;
@property (nonatomic,readonly) UIButton *detailButton;
@property (nonatomic,readonly) UIWebView *descriptionView;

@property (nonatomic,retain) Article *article;
@property (nonatomic,retain) NSIndexPath *indexPath;

@end
