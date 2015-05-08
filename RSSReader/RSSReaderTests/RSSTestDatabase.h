//
//  RSSTestDatabase.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-19.
//
//

#import "RSSDatabase.h"

@interface RSSTestDatabase : RSSDatabase
+ (void) createTestDatabase;
+ (void) removeTestDatabase;
@end
