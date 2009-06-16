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
#define LOTSDATA_NUMBER_KEY		@"LOTSDATA_NUMBER_KEY"
#define LOTSDATA_STRING_KEY		@"LOTSDATA_STRING_KEY"
#define LOTSDATA_REPEAT_KEY		@"LOTSDATA_REPEAT_KEY"

#define DATA_PLIST @"saved_lots.plist"

//@interface @interface PickOneForMeAppDelegate : NSObject <UIApplicationDelegate>
//@property (nonatomic, retain) NSMutableArray *lotsData;
//@end


@implementation PickOneForMeAppDelegate

@synthesize window;
@synthesize navigationController;
//@synthesize lotsData;


#pragma mark -
#pragma mark Application lifecycle


- (void) serializeImages: (NSMutableArray*) images withFilePath:(NSString *)filePath 
{
	NSString *errorDesc = nil;
	
	//convert UIImage to NSData first
	NSMutableArray *photoData = [NSMutableArray arrayWithCapacity:images.count];
	for(int i=0;i<images.count;++i)
	{
		NSMutableArray *array = [NSMutableArray arrayWithCapacity:((NSArray*)[images objectAtIndex:i]).count];
		for(int j=0;j<((NSArray*)[images objectAtIndex:i]).count;++j)
		{
			[array addObject:UIImagePNGRepresentation([((NSArray*)[images objectAtIndex:i]) objectAtIndex:j])];
		}
		[photoData addObject:array];
	}
	
	NSData *plistData = [NSPropertyListSerialization dataFromPropertyList:photoData
																   format:NSPropertyListXMLFormat_v1_0
														 errorDescription:&errorDesc];
	if (plistData) {
		[plistData writeToFile:filePath atomically:YES];
	}
	else {
		NSLog(errorDesc);
		[errorDesc release];
	}
}

- (void) deserializeLotsImagesAtIndex:(int)index
{
	if(((LotsData*)[lotsData objectAtIndex:index]).photoLots != nil)
	   return;
	NSTimeInterval t = [((LotsData*)[lotsData objectAtIndex:index]).lotsDate timeIntervalSince1970];
	int t_sec = t;
	NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%d", t_sec] ];
	NSString *errorDesc = nil;
	NSPropertyListFormat format;
	NSMutableArray *srcData;
	
	NSData *plistXML = [[NSFileManager defaultManager] contentsAtPath:filePath];
	srcData = (NSMutableArray *)[NSPropertyListSerialization
				propertyListFromData:plistXML
					mutabilityOption:NSPropertyListMutableContainersAndLeaves
							  format:&format errorDescription:&errorDesc];
	if (!srcData) {
		NSLog(errorDesc);
		[errorDesc release];
	}	
	
	//convert NSData to UIImage first
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
	((LotsData*)[lotsData objectAtIndex:index]).photoLots = photoData;
	//[photoData release]; //release causes bad access error
}


- (void) serializeDataWithFilePath:(NSString *)filePath
{
	NSString *errorDesc = nil;
	
	NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[lotsData count]];
	for(LotsData * lData in lotsData)
	{
		if(lData.dataChanged)
		{
			NSTimeInterval t = [lData.lotsDate timeIntervalSince1970];
			int t_sec = t;
			NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			NSString *fPath = [documentsDirectory stringByAppendingPathComponent: [NSString stringWithFormat:@"%d", t_sec] ];
			[self serializeImages: lData.photoLots withFilePath:fPath];
		}
		
		NSDictionary *dict = [NSDictionary 
				dictionaryWithObjectsAndKeys:
			lData.lotsName, LOTSDATA_NAME_KEY,
			lData.lotsDate, LOTSDATA_DATE_KEY,
			lData.numberOfGroup, LOTSDATA_NUM_GROUP_KEY,
			lData.groupTypes, LOTSDATA_GROUP_KEY,
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
		
		lData.groupTypes = [dict objectForKey:LOTSDATA_GROUP_KEY];
		lData.numberLots = [dict objectForKey:LOTSDATA_NUMBER_KEY];
		lData.stringLots = [dict objectForKey:LOTSDATA_STRING_KEY];
		lData.repeatables = [dict objectForKey:LOTSDATA_REPEAT_KEY];
		lData.dataChanged = NO;
		lData.photoLots = nil;
		
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
        lotsData = [array retain];
        [array release];
    }
    return lotsData;
}

- (int) getLotsDataCount
{
	return lotsData.count;
}

- (id) getLotsDataAtIndex:(int)index
{
	return [lotsData objectAtIndex:index];
}

- (void) removeLotsDataAtIndex:(int)index
{
	[lotsData removeObjectAtIndex:index];
}

- (void) addLotsData: (LotsData*) lots
{
	lots.dataChanged = YES;
	[[self lotsData] addObject:lots];
}

@end

