//
//  LotsData.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LOTSDATA_NUMBER_START @"LOTSDATA_NUMBER_START"
#define LOTSDATA_NUMBER_RANGE @"LOTSDATA_NUMBER_RANGE"

@interface LotsData : NSObject {
	NSString		*lotsName;
	NSDate			*lotsDate;
	
	NSNumber		*numberOfGroup;
	NSMutableArray	*groupTypes;
	NSMutableArray	*photoLots;
	NSMutableArray	*numberLots;
	NSMutableArray	*stringLots;
	NSMutableArray	*repeatables;
	
	BOOL			dataChanged;
}

@property (nonatomic, retain) NSString			*lotsName;
@property (nonatomic, retain) NSDate			*lotsDate;
@property (nonatomic, retain) NSNumber			*numberOfGroup;
@property (nonatomic, retain) NSMutableArray	*groupTypes;
@property (nonatomic, retain) NSMutableArray	*photoLots;
@property (nonatomic, retain) NSMutableArray	*numberLots;
@property (nonatomic, retain) NSMutableArray	*stringLots;
@property (nonatomic, retain) NSMutableArray	*repeatables;
@property (nonatomic, assign) BOOL				dataChanged;


- (id) initWithNumberofGroup:(NSNumber*) nfg
					lotsName:(NSString*) name
					lotsDate:(NSDate*) date;

- (void) addGroupWithType:(NSNumber*) type
			   photosLots:(NSMutableArray*) pLots
			   numberLots:(NSDictionary*) nLots
			   stringLots:(NSMutableArray*) sLots
			   repeatable:(NSNumber*) repeat;
- (void) resetArray;

@end
