//
//  LotsData.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "LotsData.h"


@implementation LotsData
@synthesize numberOfGroup, lotsName, lotsDate;
@synthesize groupTypes, photoLots, numberLots, stringLots, repeatables;

- (id) initWithNumberofGroup:(NSNumber*) nfg
					lotsName:(NSString*) name
					lotsDate:(NSDate*) date
{
	if(self = [super init])
	{
		self.numberOfGroup = nfg;
		self.lotsName = name;
		self.lotsDate = date;

		groupTypes = [[NSMutableArray alloc] initWithCapacity:4];
		photoLots = [[NSMutableArray alloc] initWithCapacity:4];
		numberLots = [[NSMutableArray alloc] initWithCapacity:4];
		stringLots = [[NSMutableArray alloc] initWithCapacity:4];
		repeatables = [[NSMutableArray alloc] initWithCapacity:4];
	}
	return self;
}

- (void) resetArray
{
	[groupTypes removeAllObjects];
	[photoLots removeAllObjects];
	[numberLots removeAllObjects];
	[stringLots removeAllObjects];
	[repeatables removeAllObjects];
}

- (void) addGroupWithType:(NSNumber*) type
			   photosLots:(NSMutableArray*) pLots
			   numberLots:(NSDictionary*) nLots
			   stringLots:(NSMutableArray*) sLots
			   repeatable:(NSNumber*) repeat
{
	if(groupTypes.count >= self.numberOfGroup.intValue)
	{
		NSLog(@"ERROR");
		return;
	}
	[groupTypes addObject:type];
	[photoLots addObject:pLots];
	[numberLots addObject:nLots];
	[stringLots addObject:sLots];
	[repeatables addObject:repeat];
}

- (void) dealloc {
	[lotsName release];
	[lotsDate release];
	
	[groupTypes release];
	[photoLots release];
	[numberLots release];
	[stringLots release];
	[repeatables release];
    [super dealloc];
}


@end
