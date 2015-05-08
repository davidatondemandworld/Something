//
//  RSSDatabase+TestDatabase.h
//  RSSReader
//
//  Created by Andy Tung on 13-5-19.
//
//

#import "RSSDatabase.h"

@interface RSSDatabase (TestDatabase)
+ (void) createTestDatabase;
+ (void) removeTestDatabase;
@end
