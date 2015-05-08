//
//  ChannelSource.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-18.
//
//

#import <Foundation/Foundation.h>

@interface ChannelSource : NSObject{
    NSString *_name;
    NSString *_url;
    NSString *_className;
    NSString *_siteUrl;
}

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *className;
@property (nonatomic,copy) NSString *siteUrl;

@end
