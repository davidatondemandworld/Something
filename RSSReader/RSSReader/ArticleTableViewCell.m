//
//  ArticleTableViewCell.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-19.
//
//

#import "ArticleTableViewCell.h"
#import "Article.h"
#import "Utilities.h"

@interface ArticleTableViewCell()
-(void) onHeadherViewTaped:(id)sender;
@end

@implementation ArticleTableViewCell

@synthesize titleLabel=_titleLabel,dateLabel=_dateLabel,favoriteButton=_favoriteButton,detailButton=_detailButton,descriptionView=_descriptionView;

@synthesize indexPath=_indexPath;
@synthesize article=_article;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _headerView=[[UIView alloc] init];
        //_headerView.backgroundColor=[UIColor grayColor];        
        
        _titleLabel=[[UILabel alloc] init];
        _titleLabel.font=[UIFont boldSystemFontOfSize:12.0f];
        _titleLabel.textColor=[UIColor blackColor];
        //_titleLabel.backgroundColor=[UIColor redColor];
        UITapGestureRecognizer *gesture=[[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onHeadherViewTaped:)] autorelease];
        [_titleLabel addGestureRecognizer:gesture];
        _titleLabel.userInteractionEnabled=YES;
        [_headerView addSubview:_titleLabel];
        
        _dateLabel=[[UILabel alloc] init];
        _dateLabel.font=[UIFont systemFontOfSize:10.0f];
        _dateLabel.textColor=[UIColor grayColor];
        //_dateLabel.backgroundColor=[UIColor yellowColor];
        [_headerView addSubview:_dateLabel];
        
        _favoriteButton=[[UIButton alloc] init];
        [_favoriteButton setTitle:@"收藏" forState:(UIControlStateNormal)];
        [_favoriteButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        _favoriteButton.titleLabel.font=[UIFont systemFontOfSize:12.0f];     
        //_favoriteButton.backgroundColor=[UIColor blueColor];
        [_headerView addSubview:_favoriteButton];
        
        _detailButton=[[UIButton alloc] init];
        [_detailButton setTitle:@"全文" forState:(UIControlStateNormal)];
        [_detailButton setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        _detailButton.titleLabel.font=[UIFont systemFontOfSize:12.0f];
        //_detailButton.backgroundColor=[UIColor blueColor];
        [_headerView addSubview:_detailButton];         

        _descriptionView=[[UIWebView alloc] init];
        _descriptionView.backgroundColor=[UIColor clearColor];
        
        [self.contentView addSubview:_headerView];
        //[self.contentView addSubview:_descriptionView];     
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];    
    
    CGRect rect=self.contentView.frame;
    _headerView.frame=CGRectMake(0.0f, 0.0f, rect.size.width, 50.0f);
    _titleLabel.frame=CGRectMake(3.0f, 3.0f, rect.size.width-50.0f, 20.0f);
    _dateLabel.frame=CGRectMake(3.0f, 26.0f, 100.0f, 20.0f);
    _detailButton.frame=CGRectMake(rect.size.width-50.0f, 3.0f, 40.0f, 20.0f);
    _favoriteButton.frame=CGRectMake(rect.size.width-50.0f, 26.0f, 40.0f, 20.0f); 
    _descriptionView.frame=CGRectMake(0.0f,50.0f,rect.size.width,100.0f); 
    if (!_article.detailVisible) {
        [_descriptionView removeFromSuperview];
    }
    else{        
        [self.contentView addSubview:_descriptionView];
        [_descriptionView loadHTMLString:_article.descriptionHtml baseURL:nil];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setArticle:(Article *)article{
    [article retain];
    [_article release];
    _article=article;
    
    _titleLabel.text=article.title;
    _dateLabel.text=[article.pubDate stringWithFormat:@"dd/MM HH:mm"];
}

- (void)onHeadherViewTaped:(id)sender{
       
    _article.detailVisible=!_article.detailVisible;
    UITableView *tableView=[self valueForKey:@"tableView"];    
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:_indexPath] withRowAnimation:(UITableViewRowAnimationFade)];
}

@end
