//
//  ChannelProviderTests.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-19.
//
//

#import "ChannelProviderTests.h"
#import "RSSDatabase+ChannelProvider.h"
#import "RSSDatabase+TestDatabase.h"
#import "Channel.h"

@implementation ChannelProviderTests

- (void)setUp
{
    [super setUp];
    // Set-up code here.
    [RSSDatabase createTestDatabase];
}

- (void)tearDown
{
    // Tear-down code here.
    [RSSDatabase removeTestDatabase];
    [super tearDown];
}

- (void)testSelectByCategoryId{
    NSArray *items=[[RSSDatabase sharedDatabase] selectChannelsByCategoryId:1];
    int count=[items count];
    STAssertEquals(2, count, @"select channels by category id failed");
}

- (void)testSelectById{   
    Channel *item=[[RSSDatabase sharedDatabase] selectChannelById:1];
    STAssertNotNil(item, @"select channel by id failed");
    STAssertEquals(1, item.categoryId, @"select channel by id failed");
    STAssertEqualObjects(@"足球", item.title, @"select channel by id failed");
    STAssertEqualObjects(@"http://rss.sina.con.cn/football.xml", item.url, @"select channel by id failed");
    STAssertEqualObjects(@"足球", item.desc, @"select channel by id failed");
}

- (void)testSelectByURLString{
    Channel *item=[[RSSDatabase sharedDatabase] selectChannelByURLString:@"http://rss.sina.con.cn/football.xml"];
    STAssertNotNil(item, @"select channel by url string failed");
    STAssertEquals(1, item.categoryId, @"select channel by url string failed");
    STAssertEqualObjects(@"足球", item.title, @"select channel by url string failed");
    STAssertEqualObjects(@"http://rss.sina.con.cn/football.xml", item.url, @"select channel by url string failed");
    STAssertEqualObjects(@"足球", item.desc, @"select channel by url string failed");
}

- (void)testInsert
{
    Channel *item=[[[Channel alloc] init]autorelease];
    item.categoryId=2;
    item.title=@"舞蹈";
    item.url=@"http://rss.sina.con.cn/dance.xml";
    item.desc=@"舞蹈";

    int rc=[[RSSDatabase sharedDatabase] insertChannel:item error:nil];
    STAssertEquals(0, rc, @"insert channel failed");
    STAssertEquals(4, item.ID, @"insert channel failed");
}

- (void)testUpdate
{
    Channel *item=[[[Channel alloc] init]autorelease];
    item.ID=1;
    item.categoryId=2;
    item.title=@"舞蹈";
    item.url=@"http://rss.sina.con.cn/football_update.xml";
    item.desc=@"舞蹈";
    
    int rc=[[RSSDatabase sharedDatabase] updateChannel:item error:nil];
    STAssertEquals(0, rc, @"update channel failed");
    
    Channel *item2=[[RSSDatabase sharedDatabase] selectChannelByURLString:item.url];
    STAssertNotNil(item2, @"update channel failed");
}

- (void)testDelete{
    Channel *item=[[[Channel alloc] init] autorelease];
    item.ID=1;
    
    int rc=[[RSSDatabase sharedDatabase] deleteChannel:item error:nil];
    STAssertEquals(0, rc, @"delete channel failed");
    
    Channel *item2=[[RSSDatabase sharedDatabase] selectChannelById:item.ID];
    STAssertNil(item2, @"delete channel failed");
}

@end
