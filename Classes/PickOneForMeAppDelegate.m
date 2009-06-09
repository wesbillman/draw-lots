//
//  PickOneForMeAppDelegate.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/6.
//  Copyright Appiness Software 2009. All rights reserved.
//

#import "PickOneForMeAppDelegate.h"
#import "RootViewController.h"

#define DATA_PLIST @"saved_lots.plist"

@implementation PickOneForMeAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize lotsData;


#pragma mark -
#pragma mark Application lifecycle

#if 0
- (void) serializeDataWithFilePath:(NSString *)filePath
{
	NSString *errorDesc = nil;
	
	NSMutableArray *data = [[NSMutableArray alloc] initWithCapacity:[alarms count]];
	for(Alarm * alarm in alarms)
	{
		NSDictionary *dict = [NSDictionary 
				dictionaryWithObjectsAndKeys:
			alarm.repeat, ALARM_KEY_REPEAT,
			alarm.snooze, ALARM_KEY_SNOOZE,
			alarm.label, ALARM_KEY_LABEL,
			[NSNumber numberWithInteger:alarm.time.hour], ALARM_KEY_TIMEHOUR,
			[NSNumber numberWithInteger:alarm.time.minute], ALARM_KEY_TIMEMINUTE,
			alarm.enable, ALARM_KEY_ENABLE, nil];
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
	
	alarms = [[NSMutableArray alloc] initWithCapacity:16];
	for(NSDictionary * dict in data)
	{
		Alarm *alarm = [[Alarm alloc] initWithLabel: [dict objectForKey:ALARM_KEY_LABEL]];
		alarm.repeat = [dict objectForKey:ALARM_KEY_REPEAT];
		alarm.snooze = [dict objectForKey:ALARM_KEY_SNOOZE];
		[alarm.time setHour:((NSNumber*)[dict objectForKey:ALARM_KEY_TIMEHOUR]).integerValue];
		[alarm.time setMinute:((NSNumber*)[dict objectForKey:ALARM_KEY_TIMEMINUTE]).integerValue];
		alarm.enable = [dict objectForKey:ALARM_KEY_ENABLE];
		[alarms addObject:alarm];
	}
}
#endif

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
    // Override point for customization after app launch    
#if 0
	NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDirectory = [paths objectAtIndex:0];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:ALARMS_PLIST];
	
	//only for debug purpose
	//	[[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
	{
		[[NSFileManager defaultManager] createFileAtPath:filePath 
												contents:nil
											  attributes:nil];
		alarms = [[NSMutableArray alloc] initWithCapacity:16];
		[self serializeDataWithFilePath:filePath];
	}
	else
	{
		[self deserializeDataWithFilePath:filePath];
	}
#endif	
	[window addSubview:[navigationController view]];
    [window makeKeyAndVisible];
	srand(time(0));
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
#if 0
	if(lotsData)
	{
		NSArray *paths =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *filePath = [documentsDirectory stringByAppendingPathComponent:DATA_PLIST];
		[self serializeDataWithFilePath:filePath];
    }
#endif
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

