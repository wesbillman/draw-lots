//
//  PickOneForMeAppDelegate.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/6.
//  Copyright Appiness Software 2009. All rights reserved.
//

#import "PickOneForMeAppDelegate.h"
#import "RootViewController.h"
#import "LotsData.h"


#define LOTSDATA_NAME_KEY		@"LOTSDATA_NAME_KEY"
#define LOTSDATA_DATE_KEY		@"LOTSDATA_DATE_KEY"
#define LOTSDATA_NUM_GROUP_KEY	@"LOTSDATA_NUM_GROUP_KEY"
#define LOTSDATA_GROUP_KEY		@"LOTSDATA_GROUP_KEY"
#define LOTSDATA_PHOTO_KEY		@"LOTSDATA_PHOTO_KEY"
#define LOTSDATA_NUMBER_KEY		@"LOTSDATA_NUMBER_KEY"
#define LOTSDATA_STRING_KEY		@"LOTSDATA_STRING_KEY"
#define LOTSDATA_REPEAT_KEY		@"LOTSDATA_REPEAT_KEY"

#define DATA_PLIST @"saved_lots.plist"

@implementation PickOneForMeAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize lotsData;


#pragma mark -
#pragma mark Application lifecycle

- (void) serializeDataWithFilePath:(NSString *)filePath
{
	NSString *errorDesc = nil;
	
	NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[lotsData count]];
	for(LotsData * lData in lotsData)
	{
		//convert UIImage to NSData first
		NSMutableArray *photoData = [NSMutableArray arrayWithCapacity:lData.photoLots.count];
		for(int i=0;i<lData.photoLots.count;++i)
		{
			NSMutableArray *array = [NSMutableArray arrayWithCapacity:((NSArray*)[lData.photoLots objectAtIndex:i]).count];
			for(int j=0;j<((NSArray*)[lData.photoLots objectAtIndex:i]).count;++j)
			{
				[array addObject:UIImagePNGRepresentation([((NSArray*)[lData.photoLots objectAtIndex:i]) objectAtIndex:j])];
			}
			[photoData addObject:array];
		}
		
		NSDictionary *dict = [NSDictionary 
				dictionaryWithObjectsAndKeys:
			lData.lotsName, LOTSDATA_NAME_KEY,
			lData.lotsDate, LOTSDATA_DATE_KEY,
			lData.numberOfGroup, LOTSDATA_NUM_GROUP_KEY,
			lData.groupTypes, LOTSDATA_GROUP_KEY,
			photoData, LOTSDATA_PHOTO_KEY,
			lData.numberLots, LOTSDATA_NUMBER_KEY,
			lData.stringLots, LOTSDATA_STRING_KEY,
			lData.repeatables, LOTSDATA_REPEAT_KEY,
			nil];
		[data addObject:dict];
	}
	
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:data
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&errorDesc];
	if (plistData) {
		[plistData writeToFile:filePath atomically:YES];
	}
	else {
		NSLog(errorDesc);
		[errorDesc release];
	}
	[data release];
}

- (void) deserializeDataWithFilePath:(NSString *)filePath
{
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSMutableArray *data;
	
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:filePath];
	data = (NSMutableArray *)[NSPropertyListSerialization
				propertyListFromData:plistXML
					mutabilityOption:NSPropertyListMutableContainersAndLeaves
							  format:&format errorDescription:&errorDesc];
	if (!data) {
		NSLog(errorDesc);
		[errorDesc release];
	}	
	
	lotsData = [[NSMutableArray alloc] initWithCapacity:16];
	for(NSDictionary * dict in data)
	{
		NSString *name = [dict objectForKey:LOTSDATA_NAME_KEY];
		NSDate *date = [dict objectForKey:LOTSDATA_DATE_KEY];
		NSNumber *numberOfGroup = [dict objectForKey:LOTSDATA_NUM_GROUP_KEY];
		LotsData *lData = [[LotsData alloc] initWithNumberofGroup:numberOfGroup lotsName:name lotsDate:date];
		
		//convert NSData to UIImage first
		NSMutableArray *srcData = [dict objectForKey:LOTSDATA_PHOTO_KEY];
		NSMutableArray *photoData = [NSMutableArray arrayWithCapacity:srcData.count];
		for(int i=0;i<srcData.count;++i)
		{
			NSMutableArray *array = [NSMutableArray arrayWithCapacity:((NSArray*)[srcData objectAtIndex:i]).count];
			for(int j=0;j<((NSArray*)[srcData objectAtIndex:i]).count;++j)
			{
				[array addObject:[UIImage imageWithData:[((NSArray*)[srcData objectAtIndex:i]) objectAtIndex:j]]];
			}
			[photoData addObject:array];
		}
		lData.groupTypes = [dict objectForKey:LOTSDATA_GROUP_KEY];
		lData.photoLots = photoData;
		lData.numberLots = [dict objectForKey:LOTSDATA_NUMBER_KEY];
		lData.stringLots = [dict objectForKey:LOTSDATA_STRING_KEY];
		lData.repeatables = [dict objectForKey:LOTSDATA_REPEAT_KEY];
		
		[lotsData addObject:lData];
		[lData release];
	}
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
	NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DATA_PLIST];
	
	//only for debug purpose
	//	[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		[[NSFileManager defaultManager] createFileAtPath:filePath 
												contents:nil
											  attributes:nil];
		lotsData = [[NSMutableArray alloc] initWithCapacity:16];
		[self serializeDataWithFilePath:filePath];
	}
	else
	{
		[self deserializeDataWithFilePath:filePath];
	}

	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	srand(time(0));
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
	if(lotsData)
	{
		NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DATA_PLIST];
		[self serializeDataWithFilePath:filePath];
    }
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[lotsData release];
	[navigationController release];
	[window release];
	[super dealloc];
}

- (NSMutableArray *) lotsData {
    if (lotsData == nil) {
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:16];
        self.lotsData = array;
        [array release];
    }
    return lotsData;
}

@end

