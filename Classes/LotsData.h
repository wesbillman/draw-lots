//
//  LotsData.h
//  PickOneForMe
//
//  Created by Chung Glen on 2009/6/7.
//  Copyright 2009 Appiness Software. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LotsData : NSObject {
	NSInteger		numberOfGroup;
	NSString		*lotsName;
	NSDate			*lotsDate;
	
	NSInteger		group1Type;
	NSInteger		group2Type;

	NSMutableArray	*photoLots1;
	NSMutableArray	*photoLots2;
	NSRange			numberLots1;
	NSRange			numberLots2;
	NSMutableArray	*stringLots1;
	NSMutableArray	*stringLots2;
}

@property (nonatomic, assign) NSInteger			numberOfGroup;
@property (nonatomic, retain) NSString			*lotsName;
@property (nonatomic, retain) NSDate			*lotsDate;
@property (nonatomic, assign) NSInteger			group1Type;
@property (nonatomic, assign) NSInteger			group2Type;

@property (nonatomic, retain) NSMutableArray	*photoLots1;
@property (nonatomic, retain) NSMutableArray	*photoLots2;
@property (nonatomic, assign) NSRange			numberLots1;
@property (nonatomic, assign) NSRange			numberLots2;
@property (nonatomic, retain) NSMutableArray	*stringLots1;
@property (nonatomic, retain) NSMutableArray	*stringLots2;

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
				 stringLots2:(NSMutableArray*) sLots2;

@end
