//
//  CategoryProviderTests.m
//  RSSReader
//
//  Created by Andy Tung on 13-5-17.
//
//

#import "CategoryProviderTests.h"
#import "RSSDatabase+CategoryProvider.h"
#import "RSSDatabase+TestDatabase.h"
#import "CategoryInfo.h"
@implementation CategoryProviderTests

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

- (void)testSelectAll{
    NSArray *items=[[RSSDatabase sharedDatabase] selectAllCategories];
    int count=[items count];
    STAssertEquals(3, count, @"select all categories failed");
}

- (void)testSelectByName{
    NSString *name=@"娱乐新闻";
    CategoryInfo *item=[[RSSDatabase sharedDatabase] selectCategoryByName:name];
    STAssertNotNil(item, @"select category by name failed");
    STAssertEquals(3, item.ID, @"select category by name failed");
}

- (void) testSelectMaxIndex{
    int index=[[RSSDatabase sharedDatabase] selectMaxCategoryOrderIndex];
    STAssertEquals(2, index, @"select category max index failed");
}

- (void)testInsert
{
    CategoryInfo *item=[[[CategoryInfo alloc] init] autorelease];
    item.name=@"测试名称";
    
    int rc=[[RSSDatabase sharedDatabase] insertCategory:item error:nil];
    STAssertEquals(0, rc, @"insert category failed");
    STAssertEquals(4, item.ID, @"insert category failed"); 
}

- (void)testUpdate
{
    CategoryInfo *item=[[[CategoryInfo alloc] init] autorelease];
    item.ID=1;
    item.name=@"测试名称";
    
    int rc=[[RSSDatabase sharedDatabase] updateCategory:item error:nil];
    STAssertEquals(0, rc, @"update category failed");
    
    CategoryInfo *item2=[[RSSDatabase sharedDatabase] selectCategoryByName:item.name];
    STAssertNotNil(item2, @"update category failed");
}

- (void)testDelete{
    CategoryInfo *item=[[[CategoryInfo alloc] init] autorelease];
    item.ID=1;    
    
    int rc=[[RSSDatabase sharedDatabase] deleteCategory:item error:nil];
    STAssertEquals(0, rc, @"delete category failed");
    
    CategoryInfo *item2=[[RSSDatabase sharedDatabase] selectCategoryById:item.ID];
    STAssertNil(item2, @"delete category failed");
}

@end
