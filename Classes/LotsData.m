//
//  LotsData.m
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import "LotsData.h"


@implementation LotsData
@synthesize numberOfGroup, lotsName, lotsDate, group1Type, group2Type, photoLots1, photoLots2, numberLots1, numberLots2, stringLots1, stringLots2;
@synthesize repeatableLots1, repeatableLots2;

- (id) initWithNumberofGroup:(NSInteger) nfg
					lotsName:(NSString*) name
					lotsDate:(NSDate*) date
				  group1Type:(NSInteger) type1
				  group2Type:(NSInteger) type2
				  photoLots1:(NSMutableArray*) pLots1
				  photoLots2:(NSMutableArray*) pLots2
				 numberLots1:(NSRange) nLots1
				 numberLots2:(NSRange) nLots2
				 stringLots1:(NSMutableArray*) sLots1
				 stringLots2:(NSMutableArray*) sLots2
{
	if(self = [super init])
	{
		self.numberOfGroup = nfg;
		self.lotsName = name;
		self.lotsDate = date;
		self.group1Type = type1;
		self.group2Type = type2;
		self.photoLots1 = pLots1;
		self.photoLots2 = pLots2;
		self.numberLots1 = nLots1;
		self.numberLots2 = nLots2;
		self.stringLots1 = sLots1;
		self.stringLots2 = sLots2;
		self.repeatableLots1 = self.repeatableLots2 = YES;
	}
	return self;
}

- (void)dealloc {
	[lotsName release];
	[lotsDate release];
	[photoLots1 release];
	[photoLots2 release];
	[stringLots1 release];
	[stringLots2 release];
    [super dealloc];
}


@end
