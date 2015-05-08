//
//  OSDBManage.m
//  Oversea
//
//  Created by ldtxinkai@gmail.com on 11-8-14.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "XDBManage.h"
#define LOCAL_DB_FOLDER @"/db/"
#define LOCAL_DB_NAME   @"address.sqlite"


@implementation XDBManage
static FMDatabase *_localDb;

+ (NSString*) getLocalDBFolder
{
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
	NSString *pathDir = [paths objectAtIndex:0];
	NSString *dbDir = [pathDir stringByAppendingPathComponent:LOCAL_DB_FOLDER];
	return dbDir;
}

+ (NSString*) getLocalDBPath
{	
	NSString *dbFolder = [XDBManage getLocalDBFolder];
	NSString *path = [dbFolder stringByAppendingPathComponent:LOCAL_DB_NAME];
	return path;
}


+ (void) copyDatabaseToDestFolder
{
	NSString *srcPath=[[NSBundle mainBundle] bundlePath];
	NSString *path = [XDBManage getLocalDBPath];
	
	NSFileManager *fm=[NSFileManager defaultManager];
	
	if (![fm fileExistsAtPath:path])
	{
		if(![fm createDirectoryAtPath:[XDBManage getLocalDBFolder] withIntermediateDirectories:NO attributes:nil error:NULL])
		{
			NSLog(@"创建数据库文件夹失败!\n");
		}
		
		if (![fm copyItemAtPath:[NSString stringWithFormat:@"%@/%@", srcPath, LOCAL_DB_NAME] toPath:path error:NULL])
		{
			UIAlertView *alert=[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Fail Title",nil) message:NSLocalizedString(@"Fail To Copy Database File",nil) delegate:self cancelButtonTitle:NSLocalizedString(@"Ok",nil) otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
	}
}

+ (FMDatabase*) getLocalDatabase
{
	if (_localDb==nil) 
	{
        [XDBManage copyDatabaseToDestFolder];
        
		NSString *path=[XDBManage getLocalDBPath];
		_localDb=[[FMDatabase alloc] initWithPath:path];
		if (![_localDb open])
		{
			NSLog(@"Could not open LocalDabase.\n");
			[_localDb release];
			_localDb=nil;
		}else {
			NSLog(@"localDB=%@\n",path);
		}
	}
	return _localDb;
}

+ (void) releaseLocalDatabase
{
	if( _localDb )
	{
		[_localDb close];
        _localDb=nil;
	}
}

@end
